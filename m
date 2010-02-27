Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44780 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030770Ab0B0UZL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 15:25:11 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Drapko Nitzhonot <drapkos@gmail.com>
Subject: Re: Status of http://patchwork.kernel.org/patch/56785/
Date: Sat, 27 Feb 2010 21:24:31 +0100
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
References: <753864a31002271218r7fce0601l51f78efdf2576f75@mail.gmail.com>
In-Reply-To: <753864a31002271218r7fce0601l51f78efdf2576f75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002272124.31863.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 27 February 2010 21:18:39 Drapko Nitzhonot wrote:
> Hi,
> I've been using this patch for over one month and it resolves my
> problem with ath5k in AP mode.
> Before patch, I got "ath5k phy0: no further txbuf available, dropping
> packet" and I had to restart hostapd
> to make it to work again.
> 
> Does anybody knows if this patch will be finally apply to kernel?

I think it is upstream through wireless-testing.
However, to say it once again, this is a -stable candidate.
(And while we are at it, that ath5k_dont_use_external_sleep_clock_in_AP_mode.patch
also is a stable candidate).

An AP running 2.6.32 is unusable without those two patches.
However, it's rock stable as soon as those are applied.

-- 
Greetings, Michael.
