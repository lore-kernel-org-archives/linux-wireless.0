Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57534 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab1EIVDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 17:03:33 -0400
Date: Mon, 9 May 2011 22:03:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Mike Ricketts <mike@earth.li>, 625953@bugs.debian.org
Cc: Geoff Simmons <gsimmons@gsimmons.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Bug#625953: linux-2.6: orinoco_pci module is no longer present
Message-ID: <20110509210324.GM2268@decadent.org.uk> (sfid-20110509_230344_705327_FD4A855E)
References: <20110507103107.3576.18188.reportbug@wibble.chf>
 <20110507142643.GC2616@chmmr.gsimmons.org>
 <Pine.LNX.4.64.1105091949450.32120@heaven.on.earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <Pine.LNX.4.64.1105091949450.32120@heaven.on.earth.li>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 09, 2011 at 07:51:43PM +0100, Mike Ricketts wrote:
> On Sun, 8 May 2011, Geoff Simmons wrote:
> 
> >The hostap driver provides better support for Prism 2/2.5/3-based PCI
> >devices, including firmware downloading and WPA support.  Consider using
> >the available hostap_pci module.
> >
> I have finally had time to try this.  The hostap_pci module does not
> work at all for my card.  It detects it, and allows me to configure
> it, but it does not actually send or receive any packets :(
 
Please can you provide some information about the hardware (from lspci)
and the driver log messages from hostap_pci.  Your initial bug report was
missing these.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
