Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42307 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260Ab1LBXdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 18:33:32 -0500
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id E67CD2132D
	for <linux-wireless@vger.kernel.org>; Fri,  2 Dec 2011 18:33:31 -0500 (EST)
Date: Fri, 2 Dec 2011 15:32:56 -0800
From: Greg KH <greg@kroah.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Johan Hovold <jhovold@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: stable-3.1: iwlwifi broken with nomsi
Message-ID: <20111202233256.GA605@kroah.com> (sfid-20111203_003337_430817_E43E4BC0)
References: <20111128195939.GA15362@localhost>
 <20111202231858.GC6016@kroah.com>
 <1322864922.13074.27.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1322864922.13074.27.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 02, 2011 at 02:28:42PM -0800, Guy, Wey-Yi wrote:
> On Fri, 2011-12-02 at 15:18 -0800, Greg KH wrote:
> > On Mon, Nov 28, 2011 at 08:59:39PM +0100, Johan Hovold wrote:
> > > Hi Greg, 
> > > 
> > > I believe commit 63665158282dd3b5d70 (iwlwifi: allow pci_enable_msi fail)
> > > needs to be added to the 3.1 stable tree as the driver fails to probe
> > > with MSI disabled since commit 084dd79172cb3 (iwlagn: move PCI related
> > > operations from probe and remove to PCI layer) without it:
> > 
> > I do not see commit 63665158282dd3b5d70 in Linus's tree, did you get it
> > incorrect?
> > 
> > confused,
> > 
> it is commit#8a39ef8ba0fa0410d71db8e981e887fe4fdeca88 in Linville's
> wireless tree

How nice, and what exactly can I do with that at this point in time?

{sigh}

Come on, please go read Documentation/stable_kernel_rules.txt again for
how to do this properly...

greg k-h
