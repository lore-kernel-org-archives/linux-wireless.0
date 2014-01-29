Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaA2MFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 07:05:21 -0500
Message-ID: <1390997117.4143.2.camel@jlt4.sipsolutions.net> (sfid-20140129_130525_377816_337FBB4B)
Subject: Re: [PATCH 0/5] mac80211: minor CSA fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Jan 2014 13:05:17 +0100
In-Reply-To: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com> (sfid-20140129_080118_008353_D744A46C)
References: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140129_080118_008353_D744A46C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-29 at 07:56 +0100, Michal Kazior wrote:
> Hi,
> 
> These are some patches from my multi-interface
> patchset. It's probably a good idea to apply them
> regardless of current multi-interface
> implementation acceptance.

All applied, with a fix in your first patch:

-	ieee80211_bss_info_change_notify(sdata, err);
+	ieee80211_bss_info_change_notify(sdata, changed);

johannes

