Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0041.outbound.protection.outlook.com ([104.47.34.41]:61632
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1763947AbdEXLIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 07:08:24 -0400
Date: Wed, 24 May 2017 14:08:11 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: Re: [PATCH v6] qtnfmac: introduce new FullMAC driver for Quantenna
 chipsets
Message-ID: <20170524110810.lbnb7nbarl46t52g@bars> (sfid-20170524_130955_691970_965C693B)
References: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
 <1495026753.2442.7.camel@sipsolutions.net>
 <20170518200810.pch7tivugqyjmy4d@bars>
 <1495189094.3274.2.camel@sipsolutions.net>
 <20170521170814.d7ljne2pgopymxud@bars>
 <1495434501.2653.7.camel@sipsolutions.net>
 <20170522210445.bj3zlyc4stjmojf5@bars>
 <1495609897.2665.4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495609897.2665.4.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > IIRC the idea was to use 'send_probe_response' for now and then to
> > implement the use of NL80211_RXMGMT_FLAG_ANSWERED flag in hostapd, at
> > least for probe requests for the start. But it definitely doesn't
> > make sense if you plan to get rid of this flag in the long run.
> 
> No no! I'm not saying let's get rid of it if you need it - I was saying
> we could get rid of it since it doesn't appear to be used. I think this
> is fine for your case, in fact you should probably already set it and
> then go and teach hostapd about it.

Good. Then I will move forward and attempt to teach hostapd about it.

Regards,
Sergey
