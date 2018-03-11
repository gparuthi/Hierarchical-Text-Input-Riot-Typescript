<item>
    <div class="item" id={node.tid} ref={node.tid}>
        <ul class={indent0: node.depth<=1, indent1: node.depth===2,
            indent2: node.depth===3, indent3: node.depth>3 }>
            <li>
                <input class="itemText" ref="input" type="title" id="hiddenInput" onkeyup={ edit } onclick={ focus }>
            </li>
        </ul>
    </div>
    
    <script>
        var self = this
        self.node = opts.node
        self.title = self.node.title || ""
        
        
        this.on("mount", () => {
            // set the input text value as node.title
            this.refs.input.value = self.node.title || ""
            
            // set event handlers for when the node should get focus
            self.node.on("focus", self.focus)
        })
        
        focus(){
            this.refs.input.focus()
            app.selectedNodeView = self
        }
        
        edit(e){
            self.title = self.node.title = e.target.value
        }
        
        tab(){
            // remove from parent and add node to sibling's children
            if (self.node.depth > 3)
            {
                return
            }
            // remove from parent and add to previous
            var prevSibling = self.node.getPrevSibling()
            if (prevSibling)
            {
                // remove this from parent
                self.node.parent.removeChild(self.node)
                // add this node to previous sibling
                prevSibling.addNodeAtIndex(prevSibling.children.length, self.node)
                // increment the depth
                self.node.depth +=  1
                // update
                app.update()
                // retain focus 
                self.node.trigger('focus')
            }
        }
        shifttab(){
            // remove from parent and add to parent's parent
            if (self.node.depth < 2)
            {
                return
            }

            // get new parent
            var newParent = self.node.parent.parent
            
            // get the index at which this node should be added
            let newIndex = newParent.getChildIndex(self.node.parent) + 1 
            
            // remove from parent
            self.node.parent.removeChild(self.node)

            // add node to new index
            newParent.addNodeAtIndex(newIndex, self.node)

            // modify the depth
            self.node.depth -=  1
            app.update()

            // retain focus
            self.node.trigger('focus')
        }
        
        
        
    </script>
</item>