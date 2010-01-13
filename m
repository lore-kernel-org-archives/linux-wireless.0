Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51364 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab0AMIkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 03:40:11 -0500
Received: by bwz27 with SMTP id 27so1751448bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2010 00:40:08 -0800 (PST)
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix channel setting for wext
References: <1263335327-9257-1-git-send-email-abhijeet.kolekar@intel.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 13 Jan 2010 10:40:05 +0200
In-Reply-To: <1263335327-9257-1-git-send-email-abhijeet.kolekar@intel.com> (Abhijeet Kolekar's message of "Tue\, 12 Jan 2010 14\:28\:47 -0800")
Message-ID: <878wc2tn2y.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Abhijeet Kolekar <abhijeet.kolekar@intel.com> writes:

> Patch fixes the bug at
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2139
>
> Currently we cannot set the channel using wext extension
> if we have already associated and disconnected. As
> cfg80211_mgd_wext_siwfreq will not switch the channel if ssid is set.
> This fixes it by clearing the ssid.

[...]

>  net/wireless/sme.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

This patch is not for mac80211, but cfg80211. So please use
"cfg80211:" prefix in the title.

-- 
Kalle Valo
