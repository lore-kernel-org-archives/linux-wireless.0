Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34735 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018Ab0AIIqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jan 2010 03:46:09 -0500
Date: Sat, 9 Jan 2010 10:45:21 +0200
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] cfg80211: fix 2 GHz subband calculation for
 country IEs
Message-ID: <20100109084521.GA6190@jm.kir.nu>
References: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
 <1262903097-2129-3-git-send-email-lrodriguez@atheros.com>
 <20100108131451.GA18758@jm.kir.nu>
 <43e72e891001081341j1c24b7c4i6f5bb636d8ccc81b@mail.gmail.com>
 <20100108232009.GA4840@jm.kir.nu>
 <43e72e891001081628s47474cadl5473432411162f0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e891001081628s47474cadl5473432411162f0f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 08, 2010 at 04:28:17PM -0800, Luis R. Rodriguez wrote:

> Heh alright, I'll change this to match the rx'd band first but that
> change is a bit big for stable so we'll have to deal with how we have
> it now for stable. I'll submit the changes for wireless-testing. Now
> last question -- although I haven't seen APs send country IEs for two
> bands in case we do, how do you want to treat those channels?

What exactly do you mean with sending two bands? By using the Regulatory
Extension Identifier? I didn't think we support it.. In general, I would
not bother doing anything special until someone can show that such an AP
exist.

> Does hostapd send just one band or two bands on the country IE?

Only one; it does not support Regulatory Extension Identifier and I
don't really see any point in advertising more than the current band.

-- 
Jouni Malinen                                            PGP id EFC895FA
