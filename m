Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53213 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964921Ab3DPOBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 10:01:49 -0400
Message-ID: <1366120905.8244.16.camel@jlt4.sipsolutions.net> (sfid-20130416_160154_285317_6965D803)
Subject: Re: [PATCH] mac80211: adjust initial chandefs assignments in
 ieee80211_register_hw
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Tue, 16 Apr 2013 16:01:45 +0200
In-Reply-To: <1366045446-11286-1-git-send-email-karl.beldan@gmail.com> (sfid-20130415_190820_657181_2AA6CD9F)
References: <1366045446-11286-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130415_190820_657181_2AA6CD9F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-15 at 19:04 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> I noticed that monitor interfaces by default would start on 5GHz
> while STA/AP ones would start 2GHZ - It stems from the fact that
> ieee80211_register_hw unnecessarily adjusts the local->monitor_chandef
> for each band.

Applied.

johannes

