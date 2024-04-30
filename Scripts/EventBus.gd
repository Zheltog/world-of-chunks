extends Node


signal cell_clicked(coordinates: Coordinates)
signal cell_recolored(coordinates: Coordinates, color: Color)
signal cell_occupied(coordinates: Coordinates, occupant: TankPart)
signal new_message(message: String)
signal tank_stopped()
signal tank_moved()
signal tank_escaped()
signal tank_damaged(remaining_hp: int)
