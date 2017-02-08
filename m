Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41056 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752142AbdBHIS5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 03:18:57 -0500
Message-ID: <1486541932.4603.5.camel@sipsolutions.net> (sfid-20170208_091918_378129_20B4F4E5)
Subject: Re: [PATCH] Print text for disassociation reason.
From: Johannes Berg <johannes@sipsolutions.net>
To: arekm@maven.pl
Cc: linux-wireless@vger.kernel.org
Date: Wed, 08 Feb 2017 09:18:52 +0100
In-Reply-To: <201702061453.08816.a.miskiewicz@gmail.com> (sfid-20170206_145427_070606_3E88921A)
References: <201702061453.08816.a.miskiewicz@gmail.com>
         (sfid-20170206_145427_070606_3E88921A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Don't know why it wasn't printed there with
> ieee80211_get_reason_code_string in first
> place. Works for me:
> 
> kernel: wlan0: disassociated from 04:b0:20:33:ff:1f (Reason:
> 34=DISASSOC_LOW_ACK)

This patch needs a "mac80211: " prefix, and I'd prefer no . at the end
(but that's not a hard rule)

> ps. can't send patch in normal way due to postmaster@vger weirdness,
> so inserted
> below
> 
> From c9b55bb44fe0b902f376a41fa930c9a67a438511 Mon Sep 17 00:00:00
> 2001
> From: =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
> Date: Mon, 6 Feb 2017 14:45:15 +0100
> Subject: [PATCH] Print text for disassociation reason.
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> When disassociation happens only numeric reason is printed
> in ieee80211_rx_mgmt_disassoc(). Add text variant, too.
> 
> Signed-off-by: Arkadiusz Miśkiewicz <arekm@maven.pl>

This is useless to me, please resubmit without all the fluff. You can
insert a "From: " line into the first line of the email *body* to get
the author correct, if you can't actually send it from the correct
email address. git send-email will even do that for you.

johannes
