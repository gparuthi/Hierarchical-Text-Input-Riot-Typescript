<app>
    <div id="container">
        <div class="nested">
            <item each={node in nodes} node={node} ></item> 
        </div>
    </div>
    
    
    <script>
        app = self = this
        // stores the model for the view
        self.nodes = [] 
        // initialize the root node that is not visible
        self.rootNode = new NodeHolder() 
        // initialize a node that points to the currently focussed
        self.selectedNodeView = null

        this.on("mount", () => {
            // init first node
            self.rootNode.addNewChild()
            self.update()
            self.rootNode.children[0].trigger('focus')

            // handle keyboard events
            $("#container").on('keydown', 'input', self.keyboardEventHandler);
        })
       
        // Update handler recreates the view when a new node is created or indented
        this.on("update", () => {
            // get a flat item list of the rootnode except for the rootnode 
            self.nodes = self.rootNode.getOrderedFlatNodeList().slice(1)
        })
        
        // Keyboard Event Handler
        self.keyboardEventHandler = (e) => {
            var keyCode = e.keyCode || e.which;
            
            if (e.shiftKey && keyCode == 9) { // shift-tab key
                // Unindent the current node
                e.preventDefault();
                self.selectedNodeView.shifttab()
            } else if (keyCode == 9) { // tab key
                // Indent the current node
                e.preventDefault();
                self.selectedNodeView.tab()                
            }
            if (keyCode == 13) { // enter Key
                // Add a new node as a sibling to the current node.
                e.preventDefault();
                // Get currently selected node
                let currentNode = self.selectedNodeView.node
                let newNode = null
                if (currentNode.children.length == 0){
                    // Add the new node as a sibling, i.e. as a child to the parent node at the next index of current node
                    newNode = currentNode.parent.addNewChild("", currentNode.parent.getChildIndex(currentNode) + 1)
                } else{
                    // Add a new child
                    newNode = currentNode.addNewChild("", 0)
                }
                app.update()
                newNode.trigger('focus')
            }
            if (keyCode == 38) { // up key
                e.preventDefault();
                // focus on the previous node
                self.getPrevInFlatList(self.selectedNodeView.node).trigger('focus')
                
            }
            if (keyCode == 40) { // down key
                e.preventDefault();
                // focus on the next node
                self.getNextInFlatList(self.selectedNodeView.node).trigger('focus')                
                
            }
        }

        getNextInFlatList(node) {
            let index = self.nodes.findIndex(n => n.tid === node.tid) + 1
            // cycle to the first one if end is reached
            if (index >= self.nodes.length)
                index = 0
            return self.nodes[index]
        }

        getPrevInFlatList(node) {
            let index = self.nodes.findIndex(n => n.tid === node.tid) - 1
            // cycle to the last one if end is reached
            if (index < 0)
                index = self.nodes.length - 1
            return self.nodes[index]
        }
   
    </script>
</app>