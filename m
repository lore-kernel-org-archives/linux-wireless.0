Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:22870 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab0CXGSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 02:18:00 -0400
Subject: Re: [PATCH 1/2] cfg80211: Add connection quality monitoring
 support to nl80211
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano (Nokia-D/Helsinki)" <Luciano.Coelho@nokia.com>
In-Reply-To: <43e72e891003230923r60522440vff7c1db26300ca91@mail.gmail.com>
References: <1269327754-995-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1269327754-995-2-git-send-email-juuso.oikarinen@nokia.com>
	 <43e72e891003230923r60522440vff7c1db26300ca91@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 08:14:40 +0200
Message-ID: <1269411280.10120.806.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-23 at 17:23 +0100, ext Luis R. Rodriguez wrote:
> On Tue, Mar 23, 2010 at 12:02 AM, Juuso Oikarinen
> <juuso.oikarinen@nokia.com> wrote:
> 
> > + * @NL80211_ATTR_CQM_RSSI_HYST: RSSI hysteresis in dBm
> 
> I still don't get what this particular value is for, despite this kdoc entry.
> 
>   Luis

I will submit one more patch to elaborate this doc further.

In the meanwhile, to explain it here, this value defines the minimum
value the RSSI level must change before the RSSI event can be issued
again, to limit the effect of a RSSI value that is oscillating around
the configured threshold.

-Juuso

