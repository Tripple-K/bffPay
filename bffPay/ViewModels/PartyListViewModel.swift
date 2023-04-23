//
//  PartyViewModel.swift
//  bffPay
//
//  Created by Eugene Ned on 23.04.2023.
//

import Foundation
import Combine

final class PartyListViewModel: ObservableObject {
    @Published var partiesRepo = PartyRepository()
    @Published var partyViewModels = [PartyViewModel]()
    @Published var isLoading = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        partiesRepo.$parties
            .receive(on: DispatchQueue.main)
            .map { parties in
                parties.map(PartyViewModel.init)
            }
            .sink { partyViewModels in
                self.partyViewModels = partyViewModels
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func add(_ party: Party, completion: @escaping () -> Void) {
        partiesRepo.create(party) {
            completion()
        }
    }
    
    func update(_ party: Party, completion: @escaping () -> Void) {
        partiesRepo.update(party) {
            completion()
        }
    }
    
    func delete(_ party: Party, completion: @escaping () -> Void) {
        partiesRepo.delete(party) {
            completion()
        }
    }
}
