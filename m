Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:39243 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809Ab3EVACq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 May 2013 20:02:46 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 21 May 2013 16:59:44 -0700
Subject: RE: [PATCH 2/2] cfg80211/nl80211: Add coalesce support
Message-ID: <477F20668A386D41ADCC57781B1F70430E0ADCE97D@SC-VEXCH1.marvell.com> (sfid-20130522_020249_651254_3CA9DED0)
References: <1369099918-4921-1-git-send-email-bzhao@marvell.com>
 <1369099918-4921-2-git-send-email-bzhao@marvell.com>
 <20130521232303.GX6529@pogo>
In-Reply-To: <20130521232303.GX6529@pogo>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

Thanks for your comments.

> > From: Amitkumar Karwar <akarwar@marvell.com>
> >
> > Add set/get configuration support for packet coalesce.
> >
> > This feature needs to be advertised during driver initialization.
> > Drivers can do required hardware settings based on user configuration.
> >
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> 
> I see nothing documenting clearly what this "coalesce" does.
> Can you elaborate quite a bit both on the commit log and also
> the documentation on nl80211.h what this is exactly?

will add the documentations in v2.

> It would also be good for you to express on your previous patch why
> you want the rename.

"packet coalesce" will reuse the pattern structure (and its enum definitions) defined for
WoWLAN. It's renamed so that both WoWLAN and Coalesce can make use of it.

More elaborations will be added in v2 series.

> 
> If you add this also can you please be sure to update the wiki
> for iw to document support for this?

Sure. It will be done as soon as the iw patches are merged.

Thanks,
Bing

> 
>   Luis
