Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:43144 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932846Ab3BSXRP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 18:17:15 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Joe Perches <joe@perches.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Tue, 19 Feb 2013 15:17:06 -0800
Subject: RE: [PATCH 1/2] mwifiex: coding style cleanup in bss parameter
 update
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D6CE58A@SC-VEXCH1.marvell.com> (sfid-20130220_001719_920241_5895F3F7)
References: <1360993470-4828-1-git-send-email-bzhao@marvell.com>
	 <1360993470-4828-2-git-send-email-bzhao@marvell.com>
 <1361003317.3444.4.camel@joe-AO722>
In-Reply-To: <1361003317.3444.4.camel@joe-AO722>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

Thanks for your comment.

> On Fri, 2013-02-15 at 21:44 -0800, Bing Zhao wrote:
> > From: Yogesh Ashok Powar <yogeshp@marvell.com>
> > They all can make one line.
> []
> > diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
> []
> > @@ -1485,20 +1485,15 @@ static int mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
> >  	priv->curr_bss_params.bss_descriptor.bcn_wapi_ie = NULL;
> >  	priv->curr_bss_params.bss_descriptor.wapi_offset = 0;
> >  	priv->curr_bss_params.bss_descriptor.bcn_ht_cap = NULL;
> > -	priv->curr_bss_params.bss_descriptor.ht_cap_offset =
> > -		0;
> > +	priv->curr_bss_params.bss_descriptor.ht_cap_offset = 0;
> 
> Another way to do this to reduce the visual noise it to
> create a temporary
> 	struct mwifiex_bssdescriptor *t = &priv->curr_bss_params.bss_descriptor;
> and use
> 	s/priv->curr_bss_params.bss_descriptor./t->/

This does look better.

As the patch is in wireless-next now I can make the change later.

Thanks,
Bing
