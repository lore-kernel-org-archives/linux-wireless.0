Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47319 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965638Ab3DRGoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 02:44:06 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [PATCH] net-sysfs: Add entry for nl80211 interface type
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <516F8F4B.1000504@lri.fr>
Date: Wed, 17 Apr 2013 23:43:59 -0700
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Bing Zhao <bzhao@marvell.com>, linux-netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Paul Stewart <pstew@chromium.org>
Message-Id: <BF64DFEC-CFE7-4A89-B251-8E9AF3E44642@holtmann.org> (sfid-20130418_084428_824906_613236C5)
References: <1366236369-543-1-git-send-email-bzhao@marvell.com>  (sfid-20130418_000709_842159_3005786A) <1366236590.8217.64.camel@jlt4.sipsolutions.net> <516F8F4B.1000504@lri.fr>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nicolas,

>>> Add a "wireless/nl80211_iftype" entry in the net device sysfs
>>> file structure to indicate the mode of the wireless device so
>>> it can be discovered easily from userspace.
>> 
>> What's wrong with "iw dev", i.e. netlink/nl80211?
> 
> "Do NOT screenscrape this tool, we don't consider its output stable."
> 
> So if you are in a shell script, you're basically screwed.

if you are in a shell script, you are screwed no matter what. So what is your point?

Regards

Marcel


