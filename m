Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45255 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbaAWPKR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 10:10:17 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: Re: [PATCH] mac80211_hwsim: add channel switch support
References: <1390387899-28972-1-git-send-email-johannes@sipsolutions.net>
Date: Thu, 23 Jan 2014 17:10:14 +0200
In-Reply-To: <1390387899-28972-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Wed, 22 Jan 2014 11:51:39 +0100")
Message-ID: <87k3dqn38p.fsf@purkki.adurom.net> (sfid-20140123_161022_207051_1D2947FD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
>
> Advertise to mac80211 that we can do channel switch both
> for STA and AP/GO.
> After each beacon transmission check if CSA is done and
> call ieee80211_csa_finish if needed.
>
> Change-Id: I1cb34c04f533275522236381ae14b624bec35418

Change id visible.

-- 
Kalle Valo
