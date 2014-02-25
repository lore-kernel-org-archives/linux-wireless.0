Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54008 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaBYMHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 07:07:24 -0500
Message-ID: <1393330040.4170.0.camel@jlt4.sipsolutions.net> (sfid-20140225_130729_700302_B6F153BB)
Subject: Re: [PATCH] mac80211: don't downgrade VHT20 to HT20
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Feb 2014 13:07:20 +0100
In-Reply-To: <1393327628-1078-1-git-send-email-michal.kazior@tieto.com> (sfid-20140225_123231_872299_347E9F99)
References: <1393327628-1078-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140225_123231_872299_347E9F99)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-25 at 12:27 +0100, Michal Kazior wrote:
> The check led to VHT-capable devices being unable
> to pair in VHT20 and were instead paired in HT20.

??

802.11ac says:
---
A VHT STA shall support the following features:
[...]
— 20 MHz, 40 MHz, and 80 MHz channel widths
[...]
---

so how can you have a device that's "VHT-capable" but doesn't support 40
MHz?

johannes

