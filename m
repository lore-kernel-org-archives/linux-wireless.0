Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46662 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbaAWSrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 13:47:09 -0500
Message-ID: <1390502825.4142.38.camel@jlt4.sipsolutions.net> (sfid-20140123_195000_270418_3483B4F5)
Subject: Re: [PATCH] mac80211_hwsim: add channel switch support
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Thu, 23 Jan 2014 19:47:05 +0100
In-Reply-To: <1390387899-28972-1-git-send-email-johannes@sipsolutions.net> (sfid-20140122_115147_378608_159CA734)
References: <1390387899-28972-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20140122_115147_378608_159CA734)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 11:51 +0100, Johannes Berg wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> Advertise to mac80211 that we can do channel switch both
> for STA and AP/GO.
> After each beacon transmission check if CSA is done and
> call ieee80211_csa_finish if needed.

Applied. Let's see how that goes.

johannes

