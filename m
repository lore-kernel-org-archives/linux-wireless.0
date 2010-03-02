Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38153 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab0CBUAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 15:00:40 -0500
Date: Tue, 2 Mar 2010 14:45:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH] rt2x00: fix rt2800pci compilation with SoC
Message-ID: <20100302194533.GC16620@tuxdriver.com>
References: <201003021634.50077.helmut.schaa@googlemail.com> <4B8D62CC.9040005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B8D62CC.9040005@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 02, 2010 at 08:11:08PM +0100, Gertjan van Wingerde wrote:
> On 03/02/10 16:34, Helmut Schaa wrote:
> > Compiling rt2800pci with CONFIG_RT2800PCI_SOC fails with "... rt2880pci.c:
> > error: incompatible type for argument 2 of 'rt2x00soc_probe'".
> > 
> > Fix this by using &rt2800pci_ops instead of rt2800pci_ops.
> > 
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > ---
> 
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> John, this is probably one that should go to wireless-2.6.

I agree, which is why I fixed the whitespace damage and applied it...grrr...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
