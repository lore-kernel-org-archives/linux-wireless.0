Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42254 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760100AbcINRNK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 13:13:10 -0400
Date: Wed, 14 Sep 2016 10:13:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 3/5] wlcore: sdio: Populate config firmware data
Message-ID: <20160914171303.5h4ktdwfrsfnduf6@atomide.com> (sfid-20160914_191314_459782_61BC6228)
References: <20160913215043.29454-1-tony@atomide.com>
 <20160913215043.29454-4-tony@atomide.com>
 <87intycsta.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87intycsta.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Kalle Valo <kvalo@codeaurora.org> [160914 10:09]:
> Tony Lindgren <tony@atomide.com> writes:
> 
> > Configure the config firmware names and make it available
> > in platform data.
> >
> > Let's also fix the order of the struct wilink_family_data
> > while at it.
> >
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > ---
> >  drivers/net/wireless/ti/wlcore/spi.c | 42 ++++++++++++++++++++----------------
> >  1 file changed, 24 insertions(+), 18 deletions(-)
> 
> I think the title should be:
> 
> wlcore: spi: Populate config firmware data
> 
> I can fix that during commit.

Oops sorry shift+Insert caused typo :)

Tony
