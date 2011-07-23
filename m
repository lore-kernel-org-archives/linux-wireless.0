Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56033 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab1GWJpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 05:45:18 -0400
Received: by qwk3 with SMTP id 3so1462821qwk.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jul 2011 02:45:17 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110723072126.17363.78910.stgit@mj.roinet.com>
References: <20110723072113.17363.59871.stgit@mj.roinet.com>
	<20110723072126.17363.78910.stgit@mj.roinet.com>
Date: Sat, 23 Jul 2011 11:45:17 +0200
Message-ID: <CA+icZUXivDPEANKtrb+3Ux=YJTA+Ey4iZQufuNGnyCkgx4UYpw@mail.gmail.com> (sfid-20110723_114520_764508_DF9E469A)
Subject: Re: [PATCH 3/3] ath5k: eliminate CHANNEL_* macros, use AR5K_MODE_* in channel->hw_value
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 23, 2011 at 9:21 AM, Pavel Roskin <proski@gnu.org> wrote:
> When checking for the band, use channel->band.
>
> Change ath5k_hw_nic_wakeup() and ath5k_channel_ok() to take
> ieee80211_channel.  Change ath5k_hw_radio_revision() to take
> ieee80211_band.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>
>

Tested on Atheros AR5212 chip against linux-next (next-20110722).

Feel free to add:

     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -
