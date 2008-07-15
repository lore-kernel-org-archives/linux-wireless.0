Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:58250 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbYGOTgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 15:36:17 -0400
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by low level driver
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	<1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	<1216039127.11189.15.camel@johannes.berg>
	<1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com>
	<87fxqcoaue.fsf@nokia.com> <1216109543.23746.21.camel@johannes.berg>
	<1ba2fa240807150129v4906b7bcyba66ab62b57c5d71@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 15 Jul 2008 22:35:29 +0300
In-Reply-To: <1ba2fa240807150129v4906b7bcyba66ab62b57c5d71@mail.gmail.com> (ext Tomas Winkler's message of "Tue\, 15 Jul 2008 11\:29\:50 +0300")
Message-ID: <87od4z9bzy.fsf@nokia.com> (sfid-20080715_213620_323640_ED633A3C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> writes:

[listen interval]

> This value for iwlwifi hw is derived from maximal supported beacon
> interval and size of the internal HW timers. This value is hard
> coded in the driver.

Ok, now I understand a bit better. Yes, a value like that would be
good to deliver to mac80211.

Just out of curiosity, what's the current hard coded maximum value?

-- 
Kalle Valo
