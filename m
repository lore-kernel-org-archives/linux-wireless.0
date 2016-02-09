Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20747 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861AbcBIO1M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 09:27:12 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Nishant Sarmukadam" <nishants@marvell.com>,
	"wnhuang@chromium.com" <wnhuang@chromium.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Xinming Hu <huxm@marvell.com>, Cathy Luo <cluo@marvell.com>
Subject: RE: [PATCH v3 1/3] mwifiex: register platform specific driver
Date: Tue, 9 Feb 2016 14:27:07 +0000
Message-ID: <f6882d2b077748eba10617d114da36f2@SC-EXCH04.marvell.com> (sfid-20160209_152716_510100_BFB9898C)
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com>
 <8264177.UI5sMC7XWi@wuerfel>
 <5ef981436ee64f67beef7ca1e2470c69@SC-EXCH04.marvell.com>
 <6131181.bluDODkWmt@wuerfel>
In-Reply-To: <6131181.bluDODkWmt@wuerfel>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, February 09, 2016 7:48 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Nishant Sarmukadam;
> wnhuang@chromium.com; devicetree@vger.kernel.org; Xinming Hu; Cathy Luo
> Subject: Re: [PATCH v3 1/3] mwifiex: register platform specific driver
> 
> On Tuesday 09 February 2016 13:44:16 Amitkumar Karwar wrote:
> > > > index 0000000..39b6a74
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/mwifiex.txt
> > > > @@ -0,0 +1,29 @@
> > > > +mwifiex
> > > > +------
> > > > +
> > > > +Required properties:
> > > > +
> > > > +  - name : must be "mwifiex"
> > >
> > > This is a very unusual requirement.
> > >
> > > Can you use one of the standard device names instead?
> > >
> >
> > We will make use of marvell-sd8xxx in updated version as per Rob
> Herring's suggestions.
> > It includes vendor name and a chipset/device name.
> 
> I meant the node name, not the compatible string. This should be
> something like "ethernet" or "wlan".

Thanks for clarification. I will name the node as "wlan"

Regards,
Amitkumar Karwar
