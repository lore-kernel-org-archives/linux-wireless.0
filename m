Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592Ab3CYP6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 11:58:19 -0400
Message-ID: <1364227093.17540.3.camel@jlt4.sipsolutions.net> (sfid-20130325_165823_212974_9ACAC327)
Subject: Re: [PATCH 0/3] mac80211: Enable VHT for non chanctxes drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 25 Mar 2013 16:58:13 +0100
In-Reply-To: <1364225219-18473-1-git-send-email-karl.beldan@gmail.com> (sfid-20130325_163038_571019_80ADE1B6)
References: <1364225219-18473-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130325_163038_571019_80ADE1B6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Karl,

> I don't know about the timing and who to CC if anyone.
> 
> The changes imply modifications on drivers side, which consist in replacing :
> - hw->conf.channel with hw->conf.chandef.chan
> - hw->conf.channel_type with cfg80211_get_chandef_type(&hw->conf.chandef)
> Some places could use an hw->conf.chandef.width instead of performing 
> cfg80211_get_chandef_type, but to keep it an even dummier change I just kept 
> the use of channel_type.

Looks fine to me. I'll apply this unless I hear complaints soon.

johannes

