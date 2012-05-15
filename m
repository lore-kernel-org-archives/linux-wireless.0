Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab2EOOa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:30:29 -0400
Message-ID: <1337092228.15553.0.camel@jlt3.sipsolutions.net> (sfid-20120515_163032_972974_0CDF5A0B)
Subject: Re: [PATCH] mac80211: retry auth and assoc on error 17
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 15 May 2012 16:30:28 +0200
In-Reply-To: <1337091676-29441-1-git-send-email-eliad@wizery.com> (sfid-20120515_162144_000592_97797139)
References: <1337091676-29441-1-git-send-email-eliad@wizery.com>
	 (sfid-20120515_162144_000592_97797139)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-15 at 17:21 +0300, Eliad Peller wrote:
> In some congested environments APs return
> WLAN_STATUS_AP_UNABLE_TO_HANDLE_NEW_STA on auth/assoc
> attempt. Instead of failing immediately, retry again
> in 200 msec.

I think this should be in wpa_supplicant?

johannes

