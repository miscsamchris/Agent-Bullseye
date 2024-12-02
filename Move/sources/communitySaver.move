module communitySaver::communitySaver {
    use std::signer;
    use std::string::{String, utf8};
    use std::simple_map::{SimpleMap, Self};
    // Errors
    const E_NOT_INITIALIZED: u64 = 1;

    struct CommunityList has key {
        communities: SimpleMap<address, CommunityData>,
        community_counter: u64,
    }


    struct CommunityData has store, drop, copy {
        community_id: String,
        community_name: String,
        owner: address,
        community_prompt: String,
    }
    public entry fun create_list(account: &signer){
        let community_list = CommunityList {
            communities: simple_map::create(),
            community_counter: 0,
        };
        // move the CommunityList resource under the signer account
        move_to(account, community_list);
    }
    #[view]
    public fun get_community(base_address: address, owner: address) : address acquires CommunityList {
        let community_list = borrow_global<CommunityList>(base_address);
        let community = simple_map::borrow(&community_list.communities, &owner);
        community.owner
    }
    
    public entry fun create_community(account: &signer, owner: address, community_id: String, community_name: String, community_prompt: String)  acquires CommunityList {

        let signer_address = signer::address_of(account);
        // gets the CommunityList resource
        let community_list = borrow_global_mut<CommunityList>(signer_address);
        // creates a new Task
        let counter = community_list.community_counter + 1;
        let new_community = CommunityData {
        community_id,
        owner,
        community_name,
        community_prompt
        };

        simple_map::add(&mut community_list.communities, owner, new_community);

        community_list.community_counter = counter;
    }

    public entry fun edit_community(account: &signer, owner: address, community_prompt: String) acquires CommunityList {
        let community_list = borrow_global_mut<CommunityList>(signer::address_of(account));
        let community = simple_map::borrow_mut(&mut community_list.communities, &owner);
        community.community_prompt = community_prompt;
    }

}