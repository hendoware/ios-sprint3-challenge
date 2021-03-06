import Foundation
import WatchKit

class Model {
    static let shared = Model()
    private init() {}
    
    var pokemon: [Pokemon] = []
    var searchPokemon: [Pokemon] = []
    var allPokemon: [Result] = []
    var savedPokemon: [Pokemon] = []
    
    func fetch(pokemonName: String, completion: @escaping () -> Void = {}) {
        guard
            let baseURL = URL(string: "https://pokeapi.co/api/v2"),
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            else {
                fatalError("Unable to setup url and components")
        }
        
        let nameItem = URLQueryItem(name: "pokemon", value: pokemonName)
        components.queryItems = [nameItem]
        
        guard let requestURL = components.url else {
            fatalError("Cannot build request URL")
        }
        
        let dataTask = URLSession.shared.dataTask(with: requestURL) { data, _, error in
            guard error == nil, let data = data else {
                NSLog("Could not run dataTask")
                completion()
                return
            }
            
            do {
                let result = try JSONDecoder().decode([Pokemon].self, from: data)
                self.pokemon = result
            } catch {
                NSLog("Unable to decode data into Pokemon: \(error)")
                completion()
                return
            }
        }
        
        dataTask.resume()
    }
    
    func fetchAll(completion: @escaping () -> Void = { }) {
        guard
            let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon"),
            let components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            else {
                fatalError("Unable to setup url and components")
        }
        
        guard let fetchURL = components.url else {
            fatalError("Cannot build request URL")
        }
        
        let dataTask = URLSession.shared.dataTask(with: fetchURL) { data, _, error in
            guard error == nil, let data = data else {
                NSLog("Could not run dataTask")
                completion()
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AllPokemon.self, from: data)
                self.allPokemon = result.results
            } catch {
                NSLog("Unable to decode data into Pokemon: \(error)")
                completion()
                return
            }
        }
        dataTask.resume()
    }
    
    func fetchEachPokemon(pokemonName: String, completion: @escaping () -> Void = {}) {
        var url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        url.appendPathComponent(pokemonName)
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data else {
                NSLog("Could not run dataTask")
                completion()
                return
            }
            
            do {
                let searchResult = try JSONDecoder().decode(Pokemon.self, from: data)
                self.searchPokemon.append(searchResult)
            } catch {
                NSLog("Unable to decode data into Pokemon: \(error)")
                print(url)
                completion()
                return
            }
        }
        
        dataTask.resume()
    }
    
}
