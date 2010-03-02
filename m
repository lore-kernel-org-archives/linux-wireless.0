Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:59135 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab0CBUD0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 15:03:26 -0500
Received: by fxm19 with SMTP id 19so708129fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 12:03:24 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rt2x00: fix rt2800pci compilation with SoC
Date: Tue, 2 Mar 2010 21:03:20 +0100
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
References: <201003021634.50077.helmut.schaa@googlemail.com> <4B8D62CC.9040005@gmail.com> <20100302194533.GC16620@tuxdriver.com>
In-Reply-To: <20100302194533.GC16620@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003022103.20426.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag 02 März 2010 schrieb John W. Linville:
> On Tue, Mar 02, 2010 at 08:11:08PM +0100, Gertjan van Wingerde wrote:
> > On 03/02/10 16:34, Helmut Schaa wrote:
> > > Compiling rt2800pci with CONFIG_RT2800PCI_SOC fails with "... rt2880pci.c:
> > > error: incompatible type for argument 2 of 'rt2x00soc_probe'".
> > > 
> > > Fix this by using &rt2800pci_ops instead of rt2800pci_ops.
> > > 
> > > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > > ---
> > 
> > Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
> > 
> > John, this is probably one that should go to wireless-2.6.
> 
> I agree, which is why I fixed the whitespace damage and applied it...grrr...

Oops, sorry John.

Thank you,
Helmut
