Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37036 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161387AbXBOVa3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 16:30:29 -0500
Date: Thu, 15 Feb 2007 22:30:28 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Make common function for frequency/channel  selection
Message-ID: <20070215223028.79a64b51@griffin.suse.cz>
In-Reply-To: <200702101255.21479.flamingice@sourmilk.net>
References: <200702101255.21479.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 10 Feb 2007 12:55:17 -0500, Michael Wu wrote:
> This patch creates ieee80211_set_channel and moves the channel selection
> and setting code in ieee80211_ioctl_siwfreq to this function. This allows
> IBSS code in ieee80211_sta.c to set the channel without using the wireless
> extensions interface.

Applied to my tree, thanks for the patch!

 Jiri

-- 
Jiri Benc
SUSE Labs
