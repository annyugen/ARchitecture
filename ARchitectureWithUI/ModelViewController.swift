import UIKit

struct CellData {
    let image: UIImage?
    let message: String?
}


class TableViewController: UITableViewController {
    var myIndex = 0
    var modelArray = ["house","building_04"]
    var data = [CellData]()
    var selectedText:String?
    var result = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        data = [CellData.init(image: #imageLiteral(resourceName: "House"), message: modelArray[0]), CellData.init(image: #imageLiteral(resourceName: "House1"), message: modelArray[1]), CellData.init(image: #imageLiteral(resourceName: "Screen Shot 2018-04-27 at 9.53.31 PM"), message: modelArray[2])]
        self.tableView.register(CustomCellView.self, forCellReuseIdentifier: "custom")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Display as rows //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomCellView
        cell.images = data[indexPath.row].image
        cell.message = data[indexPath.row].message
        cell.layoutSubviews()
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //Get value selected row//
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedText = self.data[indexPath.row].message
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "backToFrontSegue", sender: self)
        
    }
    
    // Segue for passing//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "backToFrontSegue"{
            let vc = segue.destination as! ViewController
            vc.textValue = selectedText!
        }
    }
}
