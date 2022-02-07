"""An example of constructing a profile with a single raw PC, that is set to run a specific operating system image (Ubuntu). It can be instantiated on any cluster, this particular Ubuntu image is available on all clusters.

Instructions:
Wait for the profile instance to start, then click on the node in the topology and choose the `shell` menu item. 
"""

# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg

# Create a portal context, needed to defined parameters
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()
 
# Add a raw PC to the request.
node = request.RawPC("node")
# Set the OS image for the node.
node.disk_image = 'urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU18-64-STD'


# Install and execute a script that is contained in the repository.
##node.addService(pg.Execute(shell="bash", command="/local/repository/changeShells.sh"))
node.addService(pg.Execute(shell="bash", command="/local/repository/setup.sh"))

node.addService(pg.Execute(shell="bash", command="/local/repository/email.sh"))

# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)
