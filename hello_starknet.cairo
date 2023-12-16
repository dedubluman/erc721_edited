use starknet::ContractAddress;

#[starknet::contract]
mod ERC721 {
    use array::SpanTrait;
    use starknet::get_caller_address;
    use array::ArrayTrait;
    use ekler::SeraphArrayTrait;
    use starknet::contract_address_const;
    use starknet::ContractAddress;
    use starknet::contract_address;
    use starknet::contract_address_to_felt252;
    use impll::IERC721;
    use intergerr::IntergerToAsciiTrait;
    use traits::Into;
    use zeroable::Zeroable;
    use traits::TryInto;
    use option::OptionTrait;

    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
        contr: felt252,
        supported_interfaces: LegacyMap<felt252, bool>,
        _base_uri: LegacyMap::<felt252, felt252>,
        _base_uri_len: felt252,
        _base_contr: LegacyMap::<felt252, felt252>,
        _base_contr_len: felt252,
        owners: LegacyMap::<u256, ContractAddress>,
        balances: LegacyMap::<ContractAddress, u256>,
        token_approvals: LegacyMap::<u256, ContractAddress>,
        /// (owner, operator)
        operator_approvals: LegacyMap::<(ContractAddress, ContractAddress), bool>,
    }
const owna: felt252 = 0x010b396134eD1aFA07Ad9B0921f2D1980A20d2edc881B0BDB357695950A7873e;
const IERC165_ID: felt252 = 0x3f918d17e5ee77373b56385708f855659a07f75997f365cf87748628532a055;
const IERC721_ID: felt252 = 0x33eb2f84c309543403fd69f0d0f363781ef06ef6faeb0131ff16ea3175bd943;
const IERC721_METADATA_ID: felt252 = 0x6069a70848f907fa57668ba1875164eb4dcee693952468581406d131081bbd;
const IERC721_RECEIVER_ID: felt252 =
    0x3a0dff5f70d80458ad14ae37bb182a728e3c8cdda0402a5daa86620bdf910bc;
const ISRC6_ID: felt252 = 0x2ceccef7f994940b3962a6c67e0ba4fcd37df7d131417c604f91e03caecc1cd;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Approval: Approval,
        Transfer: Transfer,
        ApprovalForAll: ApprovalForAll,
    }
    #[derive(Drop, starknet::Event)]
    struct Approval {
        owner: ContractAddress, 
        to: ContractAddress, 
        token_id: u256
    }
    #[derive(Drop, starknet::Event)]
    struct Transfer {
        from: ContractAddress, 
        to: ContractAddress, 
        token_id: u256
    }
    #[derive(Drop, starknet::Event)]
    struct ApprovalForAll {
        owner: ContractAddress, 
        operator: ContractAddress, 
        approved: bool
    }

    #[constructor]
     fn constructor(ref self: ContractState, _name: felt252, _symbol: felt252, _contr: Array<felt252> , __base_uri: Array<felt252> ) {
        self.name.write(_name);
        self.symbol.write(_symbol);
        self.set_base_contr(_contr);
        self.set_base_uri(__base_uri);

        self.register_interface(IERC721_ID);
        self.register_interface(IERC721_METADATA_ID);

        let mut x = 1;
        loop {
        self._mint(starknet::contract_address::contract_address_const::<0x010b396134eD1aFA07Ad9B0921f2D1980A20d2edc881B0BDB357695950A7873e>(), x);
        let y = x + 1;
        x = y;
        if y == 21 {
            break ();
        };
    }



    }

    #[external(v0)]
    impl IERC721Impl of impll::IERC721<ContractState> {
       
        
         fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
           if interface_id == IERC165_ID {
               return true;
            }
           self.supported_interfaces.read(interface_id)
        }
        fn supportsInterface(self: @ContractState, interfaceId: felt252) -> bool {
         if interfaceId == IERC165_ID {
               return true;
            }
           self.supported_interfaces.read(interfaceId)
        }
        
        fn name(self: @ContractState) -> felt252 {
            self.name.read()
        }

        fn symbol(self: @ContractState) -> felt252 {
            self.symbol.read()
        }
        fn contractURI(self: @ContractState) -> Array<felt252> {
            let mut base_urii = self._get_base_contr();
            base_urii
        }
        fn contract_uri(self: @ContractState) -> Array<felt252> {
             let mut base_urii = self._get_base_contr();
            base_urii
        }
        fn contractUri(self: @ContractState) -> Array<felt252> {
             let mut base_urii = self._get_base_contr();
            base_urii
        }
        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            assert(!account.is_zero(), 'ERC721: address zero');
            self.balances.read(account)
        }
          fn balanceOf(self: @ContractState, account: ContractAddress) -> u256 {
            assert(!account.is_zero(), 'ERC721: address zero');
            self.balances.read(account)
        }
        fn is_approved_for_all(self: @ContractState, owner: ContractAddress, operator: ContractAddress) -> bool {
            self._is_approved_for_all(owner, operator)
        }
         fn isApprovedForAll(self: @ContractState, owner: ContractAddress, operator: ContractAddress) -> bool {
            self._is_approved_for_all(owner, operator)
        }

        fn token_uri(self: @ContractState, token_id: u256) -> Array<felt252> {
            self._require_minted(token_id);
            let mut base_uri = self._get_base_uri();
            // get token_id low ascii value
            // TODO : covert entire u256 instead of just u128
            let mut ascii = token_id.low.to_ascii();
            // append it to base_uri array along with suffix
            base_uri.concat(ref ascii);
            base_uri
            
        }
          fn tokenUri(self: @ContractState, token_id: u256) -> Array<felt252> {
            self._require_minted(token_id);
            let mut base_uri = self._get_base_uri();
            // get token_id low ascii value
            // TODO : covert entire u256 instead of just u128
            let mut ascii = token_id.low.to_ascii();
            // append it to base_uri array along with suffix
            base_uri.concat(ref ascii);
            base_uri
            
        }
          fn tokenURI(self: @ContractState, token_id: u256) -> Array<felt252> {
            self._require_minted(token_id);
            let mut base_uri = self._get_base_uri();
            // get token_id low ascii value
            // TODO : covert entire u256 instead of just u128
            let mut ascii = token_id.low.to_ascii();
            // append it to base_uri array along with suffix
            base_uri.concat(ref ascii);
            base_uri
            
        }
        

        fn owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            let owner = self._owner_of(token_id);
            assert(!owner.is_zero(), 'ERC721: invalid token ID');
            owner
        }
         fn ownerOf(self: @ContractState, token_id: u256) -> ContractAddress {
            let owner = self._owner_of(token_id);
            assert(!owner.is_zero(), 'ERC721: invalid token ID');
            owner
        }

        fn get_approved(self: @ContractState, token_id: u256) -> ContractAddress {
            self._get_approved(token_id)
        }

        fn mint(ref self: ContractState, to: ContractAddress, token_id: u256) {
         assert(starknet::contract_address::contract_address_to_felt252(get_caller_address())==owna, 'error 508');
         self._mint(to, token_id);
        }

        fn transferFrom(ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256) {
            assert(self._is_approved_or_owner(get_caller_address(), token_id), 'Caller is not owner or appvored');
            self._transfer(from, to, token_id);
        }

        fn transfer_from(ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256) {
            assert(self._is_approved_or_owner(get_caller_address(), token_id), 'Caller is not owner or appvored');
            self._transfer(from, to, token_id);
        }

        fn safe_transfer_from(
            ref self: ContractState,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256,
            data: Span<felt252>
        ) {
            assert(
                self._is_approved_or_owner(get_caller_address(), token_id),
                'ERC721: unauthorized caller'
            );
            self._safe_transfer(from, to, token_id, data);
        }
    
        fn safeTransferFrom(
            ref self: ContractState,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256,
            data: Span<felt252>
        ) {
            assert(
                self._is_approved_or_owner(get_caller_address(), token_id),
                'ERC721: unauthorized caller'
            );
            self._safe_transfer(from, to, token_id, data);
        }

        fn set_approval_for_all(ref self: ContractState, operator: ContractAddress, approved: bool) {
            self._set_approval_for_all(get_caller_address(), operator, approved);
        }

        fn setApprovalForAll(ref self: ContractState, operator: ContractAddress, approved: bool) {
            self._set_approval_for_all(get_caller_address(), operator, approved);
        }

        fn approve(ref self: ContractState, to: ContractAddress, token_id: u256) {
            let owner = self._owner_of(token_id);
            // Unlike Solidity, require is not supported, only assert can be used
            // The max length of error msg is 31 or there's an error
            assert(to != owner, 'Approval to current owner');
            // || is not supported currently so we use | here
            assert((get_caller_address() == owner) | self._is_approved_for_all(owner, get_caller_address()), 'Not token owner');
            self._approve(to, token_id);
        }
    }

    #[generate_trait]
    impl StorageImpl of StorageTrait {
        fn _set_approval_for_all(ref self: ContractState, owner: ContractAddress, operator: ContractAddress, approved: bool) {
            assert(owner != operator, 'ERC721: approve to caller');
            self.operator_approvals.write((owner, operator), approved);
            self.emit(Event::ApprovalForAll(ApprovalForAll { owner, operator, approved }));
        }
        
           fn _safe_transfer(
            ref self: ContractState,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256,
            data: Span<felt252>
        ) {
            self._transfer(from, to, token_id);
        }
         
        fn register_interface(ref self: ContractState, interface_id: felt252) {
            self.supported_interfaces.write(interface_id, true);
        }
        

        fn _approve(ref self: ContractState, to: ContractAddress, token_id: u256) {
            self.token_approvals.write(token_id, to);
            self.emit(Event::Approval(Approval {owner: self._owner_of(token_id), to, token_id }));
        }
        fn _get_base_uri(self: @ContractState) -> Array<felt252> {
        let len = self._base_uri_len.read();
        let mut base_uri = ArrayTrait::<felt252>::new();
        let mut index = 0;
        loop {
            if index == len {
                break ();
            }
            base_uri.append(self._base_uri.read(index));
            index += 1;
        };
        base_uri
    }

    fn _get_base_contr(self: @ContractState) -> Array<felt252> {
        let len = self._base_contr_len.read();
        let mut base_uri = ArrayTrait::<felt252>::new();
        let mut index = 0;
        loop {
            if index == len {
                break ();
            }
            base_uri.append(self._base_contr.read(index));
            index += 1;
        };
        base_uri
    }

    fn set_base_contr(ref self: ContractState, mut base_uri: Array<felt252>) {
        let len = base_uri.len();
        let mut index = 0;
        loop {
            match base_uri.pop_front() {
                Option::Some(value) => {
                    self._base_contr.write(index, value);
                    index += 1;
                },
                Option::None(()) => {
                    break ();
                },
            };
        };
         // write length to storage
        self._base_contr_len.write(len.into());
       }
        fn set_base_uri(ref self: ContractState, mut base_uri: Array<felt252>) {
        let len = base_uri.len();
        let mut index = 0;
        loop {
            match base_uri.pop_front() {
                Option::Some(value) => {
                    self._base_uri.write(index, value);
                    index += 1;
                },
                Option::None(()) => {
                    break ();
                },
            };
        };
        // write length to storage
        self._base_uri_len.write(len.into());
    }

        fn _is_approved_for_all(self: @ContractState, owner: ContractAddress, operator: ContractAddress) -> bool {
            self.operator_approvals.read((owner, operator))
        }

        fn _owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            self.owners.read(token_id)
        }

        fn _exists(self: @ContractState, token_id: u256) -> bool {
            !self._owner_of(token_id).is_zero()
        }

         fn _get_approved(self: @ContractState, token_id: u256) -> ContractAddress {
            self._require_minted(token_id);
            self.token_approvals.read(token_id)
        }

        fn _require_minted(self: @ContractState, token_id: u256) {
            assert(self._exists(token_id), 'ERC721: invalid token ID');
        }

         fn _is_approved_or_owner(self: @ContractState, spender: ContractAddress, token_id: u256) -> bool {
            let owner = self.owners.read(token_id);
            // || is not supported currently so we use | here
            (spender == owner)
                | self._is_approved_for_all(owner, spender) 
                | (self._get_approved(token_id) == spender)
        }

        fn _transfer(ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256) {
            assert(from == self._owner_of(token_id), 'Transfer from incorrect owner');
            assert(!to.is_zero(), 'ERC721: transfer to 0');

            self._beforeTokenTransfer(from, to, token_id, 1.into());
            assert(from == self._owner_of(token_id), 'Transfer from incorrect owner');

            self.token_approvals.write(token_id, contract_address_const::<0>());

            self.balances.write(from, self.balances.read(from) - 1.into());
            self.balances.write(to, self.balances.read(to) + 1.into());

            self.owners.write(token_id, to);

            self.emit(Event::Transfer(Transfer { from, to, token_id }));

            self._afterTokenTransfer(from, to, token_id, 1.into());
        }
        
        fn _mint(ref self: ContractState, to: ContractAddress, token_id: u256) {
            assert(!to.is_zero(), 'ERC721: mint to 0');
            assert(!self._exists(token_id), 'ERC721: already minted');
            self._beforeTokenTransfer(contract_address_const::<0>(), to, token_id, 1.into());
            assert(!self._exists(token_id), 'ERC721: already minted');

            self.balances.write(to, self.balances.read(to) + 1.into());
            self.owners.write(token_id, to);
            // contract_address_const::<0>() => means 0 address
            self.emit(Event::Transfer(Transfer {
                from: contract_address_const::<0>(), 
                to,
                token_id
            }));

            self._afterTokenTransfer(contract_address_const::<0>(), to, token_id, 1.into());
        }


    
        fn _burn(ref self: ContractState, token_id: u256) {
            let owner = self._owner_of(token_id);
            self._beforeTokenTransfer(owner, contract_address_const::<0>(), token_id, 1.into());
            let owner = self._owner_of(token_id);
            self.token_approvals.write(token_id, contract_address_const::<0>());

            self.balances.write(owner, self.balances.read(owner) - 1.into());
            self.owners.write(token_id, contract_address_const::<0>());
            self.emit(Event::Transfer(Transfer {
                from: owner,
                to: contract_address_const::<0>(),
                token_id
            }));

            self._afterTokenTransfer(owner, contract_address_const::<0>(), token_id, 1.into());
        }



        fn _beforeTokenTransfer(
            ref self: ContractState, 
            from: ContractAddress, 
            to: ContractAddress, 
            first_token_id: u256, 
            batch_size: u256
        ) {}

        fn _afterTokenTransfer(
            ref self: ContractState, 
            from: ContractAddress, 
            to: ContractAddress, 
            first_token_id: u256, 
            batch_size: u256
        ) {}
    }
}

