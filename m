Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47484 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260Ab1LBXWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 18:22:40 -0500
Received: from compute4.internal (compute4.nyi.mail.srv.osa [10.202.2.44])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id B33F521191
	for <linux-wireless@vger.kernel.org>; Fri,  2 Dec 2011 18:22:39 -0500 (EST)
Date: Fri, 2 Dec 2011 15:18:58 -0800
From: Greg KH <greg@kroah.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: stable-3.1: iwlwifi broken with nomsi
Message-ID: <20111202231858.GC6016@kroah.com> (sfid-20111203_002258_142045_73F54621)
References: <20111128195939.GA15362@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111128195939.GA15362@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 28, 2011 at 08:59:39PM +0100, Johan Hovold wrote:
> Hi Greg, 
> 
> I believe commit 63665158282dd3b5d70 (iwlwifi: allow pci_enable_msi fail)
> needs to be added to the 3.1 stable tree as the driver fails to probe
> with MSI disabled since commit 084dd79172cb3 (iwlagn: move PCI related
> operations from probe and remove to PCI layer) without it:

I do not see commit 63665158282dd3b5d70 in Linus's tree, did you get it
incorrect?

confused,

greg k-h
