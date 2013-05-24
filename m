Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40975 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3EXWBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 18:01:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Ug038-00023v-B4
	for linux-wireless@vger.kernel.org; Sat, 25 May 2013 00:01:22 +0200
Message-ID: <1369432881.13623.13.camel@johannes> (sfid-20130525_000125_742375_FA3B81C3)
Subject: Re: [PATCH 0/9] cfg80211 spring cleaning
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Sat, 25 May 2013 00:01:21 +0200
In-Reply-To: <1368738218-7597-1-git-send-email-johannes@sipsolutions.net> (sfid-20130516_230344_782376_FD5FAA84)
References: <1368738218-7597-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130516_230344_782376_FD5FAA84)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-16 at 23:03 +0200, Johannes Berg wrote:
> Motivated by the bugs Ben Greear keeps reporting, I decided to do
> some locking and general cleanup in cfg80211.
> 
> This is the first series. I'm working on more changes to actually
> separate the SME and MLME code much better to avoid such strange
> issues as we had before with their state (sme_state and current_bss)
> getting confused, but that'll take a bit longer.

Applied.

johannes

