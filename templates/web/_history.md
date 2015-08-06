<a class="anchor release_tag" name="v0_0_0_dev31"></a>
<h2><a href="#v0_0_0_dev31">Tag: v0.0.0.dev31</a></h2>

##### Branch: 'Trunk'

##### by Melody Caron on 22-Jul-2014 09:46AM


Fixed xml tag issue where arguments were passed as Symbols, not Strings. This messed up
the xml tag format.

Bad syntax:
~~~ruby
xml.tag!('ip-name', try(:ip\_name, :pdm\_part\_name) || owner.class.to\_s.split('::').last)
# Shows up in xml as
# <ip-name:cisocregs/>
~~~
Good syntax:
~~~ruby
xml.tag!('ip-name', "#{try(:ip\_name, :pdm\_part\_name) ||
owner.class.to\_s.split('::').last}")
# Shows up in xml as
# <ip-name>cisocregs</ip-name>
~~~

Changes made to sidsc.rb only.

<a class="anchor release_tag" name="v0_0_0_dev30"></a>
<h2><a href="#v0_0_0_dev30">Tag: v0.0.0.dev30</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 17-Jul-2014 05:47AM


SIDSC export updates:

* Single and double quotes in bits and register descriptions are now automatically escaped
  and therefore preserved correctly in the XML output
* < and > will now render verbatim and will not be converted to an escaped version

IP\_XACT export updates:

* Changed the overall structure from MemoryMaps = Domains and AddressBlocks = Sub Blocks to
  MemoryMaps = The Owner and AddressBlocks = Domains. The net effect of this is that sub-blocks
  are flattened out with the address blocks, need to pilot further with verification to see
  if there are any problems from register naming contention from that.
* Simplified how bit paths are generated by leveraging the latest Origen path API
* Removed the HDL path attribute from AddressBlocks, doesn't make sense now that they represent
  domains rather than an RTL hierarchy

<a class="anchor release_tag" name="v0_0_0_dev29"></a>
<h2><a href="#v0_0_0_dev29">Tag: v0.0.0.dev29</a></h2>

##### Branch: 'Trunk'

##### by Melody Caron on 10-Jul-2014 15:04PM


Updated SIDSC register documentation to comprehend italics in register description.

~~~text
Syntax: *blah blah blah*
Translates to: <i>blah blah blah</i>
~~~

<a class="anchor release_tag" name="v0_0_0_dev28"></a>
<h2><a href="#v0_0_0_dev28">Tag: v0.0.0.dev28</a></h2>

##### Branch: 'Trunk'

##### by Christopher Hume on 10-Jul-2014 09:37AM


Updated SIDSC register documentation format to allow for unique register and bitField IDs.

This allows the same register and bit names to occur in different register sub-blocks. 
For example, if a module has multiple instances of a single register block, the ID names
will be unique when pulled into SSDS (a requirement for successful documentation
assembly).

Example:

A model instantiates multiple instances of "CoreRegs":

~~~ruby

  options[:num\_blks].times do |i|
    sub\_block "core#{i}",   :class\_name => 'CoreRegs',    base: 0x1500 + (i * 0x100)
  end

~~~

Where a register "core\_cfg0" is declared within CoreRegs:

~~~ruby

  reg :core\_cfg0, 0x0000, size: 8 do
    bits 7..4, :satime
    bits 3..0, :readt
  end

~~~

SIDSC conversion now attaches the component name (:component\_name, :name, or
:pdm\_part\_name) to the register and bitField ID attributes.

For core0:

~~~xml

      <register id="sidsc\_core0\_CORE\_CFG0">
        <bitField id="core0\_SATIME">
        <bitField id="core0\_READT">

~~~

And core1:

~~~xml

      <register id="sidsc\_core1\_CORE\_CFG0">
        <bitField id="core1\_SATIME">
        <bitField id="core1\_READT">

~~~

<a class="anchor release_tag" name="v0_0_0_dev27"></a>
<h2><a href="#v0_0_0_dev27">Tag: v0.0.0.dev27</a></h2>

##### Branch: 'Trunk'

##### by Stephen Traynor on 10-Jul-2014 09:02AM


Expanded capability to consume register data written in Automotive TCU Excel format, that
is
insensitive to the ordering of the bits/bitgroups.

<a class="anchor release_tag" name="v0_0_0_dev26"></a>
<h2><a href="#v0_0_0_dev26">Tag: v0.0.0.dev26</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 03-Jul-2014 03:17AM


IP\_XACT export updates:

* Filled in the name field in the bit field attributes, this will just generate a name based on the
  value like: 'val\_0x0', 'val\_0x5'
* Fixed some vendor extensions that were permanently enabled, now they will only be output when
  format: :uvm is passed to the to\_ip\_xact method
* Made the bit field values conditional but enabled by default, they can be disabled by passing
  :include\_bit\_field\_values => false to the to\_ip\_xact method

<a class="anchor release_tag" name="v0_0_0_dev25"></a>
<h2><a href="#v0_0_0_dev25">Tag: v0.0.0.dev25</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 02-Jul-2014 07:51AM


THe IP-XACT exporter will now use the bit.access attribute to fill in the corresponding
field.

<a class="anchor release_tag" name="v0_0_0_dev24"></a>
<h2><a href="#v0_0_0_dev24">Tag: v0.0.0.dev24</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 01-Jul-2014 05:30AM


Updates to the IP XACT exporter which now understands the Origen sub-block model and
conventions.

Also added initial vendor extensions to support UVM - currently working with NVM
verification to further develop this exporter and enable the Origen -> UVM flow.

<a class="anchor release_tag" name="v0_0_0_dev23"></a>
<h2><a href="#v0_0_0_dev23">Tag: v0.0.0.dev23</a></h2>

##### Branch: 'Trunk'

##### by William Forfang on 12-Jun-2014 09:14AM


Fixed the 'types' attribute extractor in pin\_tool.rb. This allows the in-console BGA
plotting widget to distinguish between package types. The SOC package type is located at
the following XML path:

/packages-supported/package/packageInformation/packageType/packageAcronym

If no packageAcronym exists in the XML, the default value of the .types attribute is set
to 'BGA\_default'.

~~~ruby
> $dut.package = :t4240
=> :t4240
> $dut.package.types
=> ["BGA\_default"]
> $dut.package.plot\_help
~~~


<a class="anchor release_tag" name="v0_0_0_dev22"></a>
<h2><a href="#v0_0_0_dev22">Tag: v0.0.0.dev22</a></h2>

##### Branch: 'Trunk'

##### by William Forfang on 12-Jun-2014 08:40AM


Added 'types' attribute to package extracted by pin\_tool.rb. Defaults to 'BGA\_default' if
no type is listed in the XML.

<a class="anchor release_tag" name="v0_0_0_dev21"></a>
<h2><a href="#v0_0_0_dev21">Tag: v0.0.0.dev21</a></h2>

##### Branch: 'Trunk'

##### by Stephen Traynor on 28-May-2014 14:37PM


Removed unnecssary line displaying :path symbol to the log in the rs\_file method in
lib/rosetta\_stone.rb

<a class="anchor release_tag" name="v0_0_0_dev20"></a>
<h2><a href="#v0_0_0_dev20">Tag: v0.0.0.dev20</a></h2>

##### Branch: 'Trunk'

##### by Stephen Traynor on 28-May-2014 11:20AM


Corrected method to import the ruby gems spreadsheet module

<a class="anchor release_tag" name="v0_0_0_dev19"></a>
<h2><a href="#v0_0_0_dev19">Tag: v0.0.0.dev19</a></h2>

##### Branch: 'Trunk'

##### by Stephen Traynor on 28-May-2014 10:05AM


adding missing files from initial release

<a class="anchor release_tag" name="v0_0_0_dev18"></a>
<h2><a href="#v0_0_0_dev18">Tag: v0.0.0.dev18</a></h2>

##### Branch: 'Trunk'

##### by Stephen Traynor on 28-May-2014 09:47AM


Included method to read TCU registers defined in excel

<a class="anchor release_tag" name="v0_0_0_dev17"></a>
<h2><a href="#v0_0_0_dev17">Tag: v0.0.0.dev17</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 28-May-2014 03:40AM


Minor update to make SIDSC export work when the component name is a symbol

<a class="anchor release_tag" name="v0_0_0_dev16"></a>
<h2><a href="#v0_0_0_dev16">Tag: v0.0.0.dev16</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 27-May-2014 08:58AM


Fix encoding issue when importing from docato on windows

<a class="anchor release_tag" name="v0_0_0_dev15"></a>
<h2><a href="#v0_0_0_dev15">Tag: v0.0.0.dev15</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 23-May-2014 05:45AM


Some debug of the RALF export format.

Added ability to import from Design Sync - now support local path, Docato or Design Sync.
See plugin homepage for an example of how to use it.

<a class="anchor release_tag" name="v0_0_0_dev14"></a>
<h2><a href="#v0_0_0_dev14">Tag: v0.0.0.dev14</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 01-May-2014 13:06PM


Added support for register export to IP-XACT and RALF (Synopsis) formats

<a class="anchor release_tag" name="v0_0_0_dev13"></a>
<h2><a href="#v0_0_0_dev13">Tag: v0.0.0.dev13</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 16-Apr-2014 08:22AM


Enabled enforced lint/style checking and fixed existing offenses.

Some tweaks to the generated SIDSC output.

<a class="anchor release_tag" name="v0_0_0_dev12"></a>
<h2><a href="#v0_0_0_dev12">Tag: v0.0.0.dev12</a></h2>

##### Branch: 'Trunk'

##### by Chris Hume on 25-Mar-2014 22:48PM


Updated to support new Register API features and format/syntax updates:

Added support for "write-one-to-clear" access (bitFieldAccess).

Implemented automated documentation of unused/empty bit positions via empty\_bits (new
Register API function).  Any unused/empty bits in a register definition will be
auto-filled with reserved bits.  Adjacent unused/empty bits are compressed into a single
bit field.  Multiple sequences of unused bits within a register will yield uniquely named
reserved locations.  Empty bit fields currently default to Read-Only Zero access. A future
update may add support for Read-Only One access to be defined on a per-register basis.

Syntax changes of note:
  * registerNameFull has been changed from all caps to simple capitilization
  * addressBlock id has been changed from using :ip\_name or :pdm\_part\_name to
:component\_name, :name, or :pdm\_part\_name.  Use of the same id name for memoryMap and
addressBlock resulted in a naming collision error in oXygen.

Note that some unused fields have been removed: bitNumbers, bitFieldRadix

If you are using the to\_sidsc method and encounter any syntax or nomenclature issues,
please contact Chris Hume at r20984@freescale.com/chris.hume@freescale.com.  To the best
of my knowledge, the TFS FMU design team is the only team leveraging SIDSC formatted XML
for documentation generation.  I only have access to our register maps and .ditamaps for
validation cases.  Examples from other teams would be welcome.

<a class="anchor release_tag" name="v0_0_0_dev11"></a>
<h2><a href="#v0_0_0_dev11">Tag: v0.0.0.dev11</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 21-Mar-2014 07:51AM


Updated the Pin Tool importer to include the busref attribute for the various
configurations
of a given pin. This is available via the pin.group method.

<a class="anchor release_tag" name="v0_0_0_dev10"></a>
<h2><a href="#v0_0_0_dev10">Tag: v0.0.0.dev10</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 13-Mar-2014 12:31PM


Added Docato workspace synchronizer. This is a wrapping of a 3rd party tool
to upload local documentation to docato.

Will fully document in due course, but basically:

~~~ruby
include CrossOrigen

def generate\_block\_guide
  my\_method\_to\_generate\_xml
  rs\_docato.sync(:local\_dir => "#{Origen.root}/output/block\_guide", :docato\_dir => "/my/docato/path")
end
~~~

A method is also provided to automatically return a path to the current user's
sandbox on docato:

~~~ruby
include CrossOrigen

def generate\_block\_guide
  my\_method\_to\_generate\_xml
  rs\_docato.sync(:local\_dir => "#{Origen.root}/output/block\_guide", :docato\_dir => rs\_docato.sandbox)
end
~~~

<a class="anchor release_tag" name="v0_0_0_dev9"></a>
<h2><a href="#v0_0_0_dev9">Tag: v0.0.0.dev9</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 07-Mar-2014 11:21AM


Removed all references to Origen pin\_api v3, and set min Origen version to the latest where
that is now the default.

Removed http Linux hacks in docato.rb, that is now fixed in latest Origen.

<a class="anchor release_tag" name="v0_0_0_dev8"></a>
<h2><a href="#v0_0_0_dev8">Tag: v0.0.0.dev8</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 20-Feb-2014 11:41AM


Initial release of Pin Tool import.

Docato import now works on both Windows and Linux and can be used in production.

<a class="anchor release_tag" name="v0_0_0_dev7"></a>
<h2><a href="#v0_0_0_dev7">Tag: v0.0.0.dev7</a></h2>

##### Branch: 'Trunk'

##### by Melody Caron on 19-Feb-2014 09:37AM


Added TPC VER2PAT file -> Origen pin definition importer.

<a class="anchor release_tag" name="v0_0_0_dev6"></a>
<h2><a href="#v0_0_0_dev6">Tag: v0.0.0.dev6</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 10-Feb-2014 03:36AM


Replaced all occurrences of <strong> with <b> in SIDSC content generated from markdown.

Removed the base\_address attribute handling in SIDCS import/export since it clashes with
Origen's existing handling of it - need a real life use case based on SIDCS to work out how
to handle this.

Internally renamed the SSDS class as Docato, since it is really concerned with talking to
the Docato revision control system rather than the more general SSDS.

<a class="anchor release_tag" name="v0_0_0_dev5"></a>
<h2><a href="#v0_0_0_dev5">Tag: v0.0.0.dev5</a></h2>

##### Branch: 'Trunk'

##### by Chris Hume on 07-Feb-2014 14:56PM


Fixed several minor formatting issues with to\_sidsc method.  Barring one exception, (noted
below), Origen register content is converted to SIDSC-compliant XML documentation via the
to\_sidsc method.

Exception: markdown-style bolded text, ex: **this is to be bold**, is incorrectly
bookended with <strong><strong/>.  This will be corrected to <b><b/> in the next release.

<a class="anchor release_tag" name="v0_0_0_dev4"></a>
<h2><a href="#v0_0_0_dev4">Tag: v0.0.0.dev4</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 27-Jan-2014 07:25AM


Some initial work on a pin tool and datasheet importer.

<a class="anchor release_tag" name="v0_0_0_dev3"></a>
<h2><a href="#v0_0_0_dev3">Tag: v0.0.0.dev3</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 13-Jan-2014 16:54PM


Added direct import from SSDS. This currently only works on Windows until the Linux Ruby
installation is updated and will not be documented on the main page until then, but here
is an example:

~~~ruby
# Instead of supplying a path to a local file an SSDS ID and version can be supplied instead
rs\_import(:ssds\_id => , version: 60)
~~~

Origen will fetch and cache the corresponding XML file in a similar way to how imports are handled.

Also added an initial module to generate C headers, this adds a to\_header method which will
currently generate a default header format for the modules registers:

~~~ruby
$dut.pmc.to\_header
~~~

<a class="anchor release_tag" name="v0_0_0_dev2"></a>
<h2><a href="#v0_0_0_dev2">Tag: v0.0.0.dev2</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 13-Dec-2013 05:21AM


Updated to latest doc helpers version in development environment to fix a couple of
register display bugs.

<a class="anchor release_tag" name="v0_0_0_dev1"></a>
<h2><a href="#v0_0_0_dev1">Tag: v0.0.0.dev1</a></h2>

##### Branch: 'Trunk'

##### by Stephen McGinty on 12-Dec-2013 11:30AM


Added SIDSC (SSDS) export capability.

Initial public API is now defined and described at:
http://origen.freescale.net/rosetta\_stone/

## Tag: v0.0.0.dev0

##### Branch: 'Trunk'

##### by Stephen McGinty on 05-Dec-2013 11:15AM


This is an initial tag of a new Origen plugin to provide import/export APIs to
interface with other Freescale tools.

For example the import APIs will allow register, pin and spec data that is
mastered somewhere else to be automatically imported and instantiated for use
within an Origen environment.

The export APIs will support the case where Origen is being used to master this
type of data as is currently being piloted by the NVM design team.

Many formats may ultimately be supported but initially the goal is to support
SIDSC (SSDS) and API-Factory.

This initial release fully supports importing SIDSC register data and has a
passing test case which imports registers for the ATX uC module from SSDS.

The public facing API is still in development and will be documented in due
course.

