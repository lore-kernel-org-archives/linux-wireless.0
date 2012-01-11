Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:57074 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329Ab2AKOQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 09:16:17 -0500
From: "Elias, Ilan" <ilane@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "samuel@sortiz.org" <samuel@sortiz.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] NFC: Download TI NFC init script
Date: Wed, 11 Jan 2012 14:15:13 +0000
Message-ID: <B30D1FD582D6484ABF57420512E580350F5D1C60@DLEE74.ent.ti.com> (sfid-20120111_151621_327970_2E38C11E)
References: <1326285768-3073-1-git-send-email-ilane@ti.com>
	 (sfid-20120111_134051_269239_A8A55A8B)
 <1326286159.3417.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1326286159.3417.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes, 
 
> > @@ -47,6 +59,36 @@ struct nfcwilink_hdr {
> >  	u16 len;
> >  } __packed;
> 
> > +struct bts_file_hdr {
> > +	u32 magic;
> 
> All this new stuff, but also the old stuff above, seems to be missing
> endian annotations.

You're correct.
I'll fix it and send a new patch.

Thanks & BR,
Ilan
