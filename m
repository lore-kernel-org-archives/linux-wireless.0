Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:30506 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab0JHLo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 07:44:56 -0400
Subject: Re: [PATCH v2 01/03] wl1271: 11n Support, Add Definitions
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286475613.1662.41.camel@powerslave>
References: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>
	 <1286388491-28752-3-git-send-email-shahar_levi@ti.com>
	 <1286475613.1662.41.camel@powerslave>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 14:44:49 +0300
Message-ID: <1286538289.21349.99.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 20:20 +0200, ext Luciano Coelho wrote:
> > diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h
> b/drivers/net/wireless/wl12xx/wl1271_conf.h
> > index 60c50d1..732e9aa 100644
> > --- a/drivers/net/wireless/wl12xx/wl1271_conf.h
> > +++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
> > @@ -91,6 +91,10 @@ enum {
> >       CONF_HW_RXTX_RATE_UNSUPPORTED = 0xff
> >  };
> >  
> > +#define HW_RX_HIGHEST_RATE   65
> > +#define HW_BG_RATES_MASK     0xffff
> > +#define HW_HT_RATES_OFFSET   16
> 
> We preceed all the other macros with CONF_, please do the same for
> these.

Actually, we use the wl1271_conf.h file only for driver configuration
parameters.  These macros should be elsewhere, such as in the wl1271.h
file.  And no need to put CONF_ before them in that case.

-- 
Cheers,
Luca.

