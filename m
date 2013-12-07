Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:55714 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754671Ab3LGWzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Dec 2013 17:55:32 -0500
Message-ID: <1386456926.31845.57.camel@joe-AO722> (sfid-20131207_235549_204524_E361F6EC)
Subject: Re: [net] nfc: Fix FSF address in file headers
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Date: Sat, 07 Dec 2013 14:55:26 -0800
In-Reply-To: <1386456552.2195.52.camel@jtkirshe-mobl>
References: <1386348976-24657-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <52A39F18.8080202@broadcom.com> <1386456552.2195.52.camel@jtkirshe-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-12-07 at 14:49 -0800, Jeff Kirsher wrote:
> On Sat, 2013-12-07 at 23:20 +0100, Arend van Spriel wrote:
> > On 12/06/2013 05:56 PM, Jeff Kirsher wrote:
> > > Several files refer to an old address for the Free Software Foundation
> > > in the file header comment.  Resolve by replacing the address with
> > > the URL<http://www.gnu.org/licenses/>  so that we do not have to keep
> > > updating the header comments anytime the address changes.
> > 
> > This seems to pop up from time to time and unfortunately the resolution 
> > seems not consistent at those times. Why not simply refer to the full 
> > license text that is in the COPYING file in the tree itself.
> 
> I, personally have only had one request in the last 10 years to change
> our Intel Wired Ethernet headers and that was because the address
> changed.  I am open to suggestions, although when I proposed either
> updating the address to the current address or use the URL on LKML and
> netdev, the response I got was to update to the use the URL.
> 
> I guess the only argument I would have against referring to the COPYING
> in the tree itself is that the headers already state:
> 
> You should have received a copy of the GNU General Public License along
> with this program;
> 
> (which refers to the COPYING file) and then it states...
> 
> if not, write to the Free Software Foundation, Inc.,
> 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> 
> This is the second part that needs cleanup if the file refers to the old
> address.  So just by removing the address and providing the URL, you are
> providing a place that users can get the license *if* the COPYING file
> gets removed (or altered) by who ever releases the kernel.

Hi Jeff.

I think what you've done is fine, but remember that
URLs come and go too.

There was a discussion about this just a bit ago on lkml
https://lkml.org/lkml/2013/10/6/158
and this message was added to checkpatch recently:

"Do not include the paragraph about writing to the Free Software
Foundation's mailing address from the sample GPL notice. The FSF has
changed addresses in the past, and may do so again. Linux already
includes a copy of the GPL.\n"


