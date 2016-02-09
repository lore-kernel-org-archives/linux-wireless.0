Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:55836 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbcBIOS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 09:18:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"wnhuang@chromium.com" <wnhuang@chromium.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Xinming Hu <huxm@marvell.com>, Cathy Luo <cluo@marvell.com>
Subject: Re: [PATCH v3 1/3] mwifiex: register platform specific driver
Date: Tue, 09 Feb 2016 15:18:18 +0100
Message-ID: <6131181.bluDODkWmt@wuerfel> (sfid-20160209_151832_150918_9B3B995A)
In-Reply-To: <5ef981436ee64f67beef7ca1e2470c69@SC-EXCH04.marvell.com>
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com> <8264177.UI5sMC7XWi@wuerfel> <5ef981436ee64f67beef7ca1e2470c69@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 09 February 2016 13:44:16 Amitkumar Karwar wrote:
> > > index 0000000..39b6a74
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/mwifiex.txt
> > > @@ -0,0 +1,29 @@
> > > +mwifiex
> > > +------
> > > +
> > > +Required properties:
> > > +
> > > +  - name : must be "mwifiex"
> > 
> > This is a very unusual requirement.
> > 
> > Can you use one of the standard device names instead?
> > 
> 
> We will make use of marvell-sd8xxx in updated version as per Rob Herring's suggestions.
> It includes vendor name and a chipset/device name.

I meant the node name, not the compatible string. This should be something
like "ethernet" or "wlan".

	Arnd
