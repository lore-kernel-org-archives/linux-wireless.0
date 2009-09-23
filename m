Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:64699 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbZIWHQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 03:16:34 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Comparison of wpa_supplicant with -Dnl80211 and -Dwext, WEP and WPA
Date: Wed, 23 Sep 2009 09:15:35 +0200
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
References: <200909221118.04569.hs4233@mail.mn-solutions.de> <200909221258.44921.hs4233@mail.mn-solutions.de> <1253689291.4458.25.camel@johannes.local>
In-Reply-To: <1253689291.4458.25.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909230915.35312.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 September 2009 09:01:31 Johannes Berg wrote:
> Because the scan request contains info on how to do the scan.

I know. I sent another mail where I said the traceback
was correct, but not my conclusion: I confused
cfg80211_wext_siwscan() and cfg80211_wext_giwscan().

I thougth the return -EBUSY is in cfg80211_wext_giwscan().

That it is in cfg80211_wext_siwscan() makes perfect sense.

-- 
http://www.holgerschurig.de
