Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3KFKLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:11:47 -0500
Message-ID: <1383732704.14307.18.camel@jlt4.sipsolutions.net> (sfid-20131106_111151_069275_BE7AF41D)
Subject: Re: [PATCH v2 5/5] cfg80211: allow beaconing after DFS CAC
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 11:11:44 +0100
In-Reply-To: <1383659329-11023-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131105_144906_140973_6384EC66)
References: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1383659329-11023-5-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131105_144906_140973_6384EC66)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-05 at 14:48 +0100, Janusz Dziedzic wrote:
> After going throught the Channel Availability Check (CAC)
> required by DFS enable beaconing. Channels that have
> gone through a CAC will be in the NL80211_DFS_AVAILABLE
> state. Without this change APs don't start beaconing
> after a successful CAC.
> Change also cfg80211_secondary_chans_ok() where handle
> prohibited_flags as prohibited.

I can't really understand this commit message - can you please rephrase
it?

johannes

