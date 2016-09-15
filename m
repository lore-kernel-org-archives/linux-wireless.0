Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51436 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751758AbcIOJE2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 05:04:28 -0400
Message-ID: <1473930264.25838.2.camel@sipsolutions.net> (sfid-20160915_110454_121826_E1C77A9F)
Subject: Re: [PATCH v5] cfg80211: Add support to configure a beacon data rate
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>,
        "Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>
Date: Thu, 15 Sep 2016 11:04:24 +0200
In-Reply-To: <0b1aa5b1fc484bb481ff5be8e187acc2@aphydexm01f.ap.qualcomm.com>
References: <1473854924-10352-1-git-send-email-pkushwah@qti.qualcomm.com>
         <1473927421.4423.38.camel@sipsolutions.net>
         (sfid-20160915_101917_590850_04C3DE8A) <1473929362.25838.0.camel@sipsolutions.net>
         <0b1aa5b1fc484bb481ff5be8e187acc2@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-09-15 at 09:00 +0000, Undekari, Sunil Dutt wrote:
> > 
> > shouldn't we have some feature flags here to indicate that the
> > driver actually supports this?
> Yes. Can you please accept this with a new commit. 
> 
I'm even willing to add it myself - should we just have three feature
flags?

AP_BEACON_RATE_LEGACY
AP_BEACON_RATE_HT
AP_BEACON_RATE_VHT

?

johannes
