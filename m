Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41567 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbYLPTLu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 14:11:50 -0500
Subject: Re: [PATCH,RFC] initial mwl8k driver for marvell topdog wireless
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081216095039.GA6358@tesla>
References: <20081216025542.GO18056@xi.wantstofly.org>
	 <1229443806.7307.34.camel@localhost.localdomain>
	 <20081216161658.GC3636@tuxdriver.com>
	 <1229449041.7307.49.camel@localhost.localdomain>
	 <20081216095039.GA6358@tesla>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 14:10:48 -0500
Message-Id: <1229454648.7307.67.camel@localhost.localdomain> (sfid-20081216_201154_994034_F220788E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-12-16 at 01:50 -0800, Luis R. Rodriguez wrote:
> On Tue, Dec 16, 2008 at 09:37:21AM -0800, Dan Williams wrote:
> > On Tue, 2008-12-16 at 11:16 -0500, John W. Linville wrote:
> > > On Tue, Dec 16, 2008 at 11:10:06AM -0500, Dan Williams wrote:
> > > > On Tue, 2008-12-16 at 03:55 +0100, Lennert Buytenhek wrote:
> > > > > Hi all,
> > > > >
> > > > > Attached is an initial version of the mwl8k driver for Marvell 88w8xxx
> > > > > PCI/PCIe wireless parts (against 2.6.27.1).  This version was written
> > > > > and tested against the 88w8687 (802.11b/g), but it shouldn't be hard to
> > > > > extend the support to other parts in the 8xxx series, since the firmware
> > > > > interface is very similar between parts.
> > > > >
> > > > > There's an occasional timeout warning with mwl8k_stop(), and hardware
> > > > > crypto is still a work-in-progress, but other than that it looks pretty
> > > > > stable.
> > > > >
> > > > > Feedback appreciated!
> > > >
> > > > Oooh, thanks for the Christmas present.  Just in time for the holidays.
> > > > Is there a git repo somewhere that we could all base off of, so we don't
> > > > have to deal with patches to patches to patches until it gets into
> > > > wireless-testing?
> > >
> > > I wouldn't worry too much about that.  The better questions is where
> > > do we get firmware?
> > 
> > I believe I can post it.  Marvell recently changed the license terms on
> > at least some of their firmware to be comparable to other freely
> > available firmware (like Intel's).  Unfortunately you must have an
> > extranet account to get it (they are working on fixing this too) but
> > once you have it, the firmware blobs themselves are under a nice
> > license.  I'll try to get something together today.
> 
> The right thing to do (tm) would be to post the firmware along with a
> friendly license by the vendor to the linux-firmware git tree.
> 
> Lennert is this possible?

If Lennert doesn't get to it, I believe that I have to power to do so.
New Marvell firmware license (at least for 8687 and 8686 sdio) is below.
It clears Fedora Legal, which is quite stringent.

Dan

----------------------
FIRMWARE LICENSE TERMS


Copyright (c) Marvell International Ltd.

All rights reserved.

Redistribution. Redistribution and use in binary form, without
modification, are permitted provided that the following conditions are
met:

* Redistributions must reproduce the above copyright notice and the
following disclaimer in the documentation and/or other materials
provided with the distribution. 

* Neither the name of Marvell International Ltd. nor the names of its
suppliers may be used to endorse or promote products derived from this
software without specific prior written permission. 

* No reverse engineering, decompilation, or disassembly of this software
is permitted.

Limited patent license. Marvell International Ltd. grants a world-wide,
royalty-free, non-exclusive license under patents it now or hereafter
owns or controls to make, have made, use, import, offer to sell and sell
("Utilize") this software, but solely to the extent that any such patent
is necessary to Utilize the software alone, or in combination with an
operating system licensed under an approved Open Source license as
listed by the Open Source Initiative at http://opensource.org/licenses.
The patent license shall not apply to any other combinations which
include this software. No hardware per se is licensed hereunder.

DISCLAIMER. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


