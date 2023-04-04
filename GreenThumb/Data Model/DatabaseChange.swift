import Combine
import SwiftUI

/**
 A class called `DatabaseChange` used for tracking changes in the database.
 
 # Properties
 - `indicator`: A boolean value used to indicate if there has been a change in the database.
 */
final class DatabaseChange: ObservableObject {
    @Published var indicator = false
}
