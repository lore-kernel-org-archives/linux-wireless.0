Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:3345 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab1GWNj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 09:39:27 -0400
Message-ID: <20110723093927.fwsus06pc04wcso8-cebfxv@webmail.spamcop.net> (sfid-20110723_153930_821380_BDD7ED65)
Date: Sat, 23 Jul 2011 09:39:27 -0400
From: Pavel Roskin <proski@gnu.org>
To: sedat.dilek@gmail.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 3/3] ath5k: eliminate CHANNEL_* macros, use AR5K_MODE_*
	in channel->hw_value
References: <20110723072113.17363.59871.stgit@mj.roinet.com>
	<20110723072126.17363.78910.stgit@mj.roinet.com>
	<CA+icZUXivDPEANKtrb+3Ux=YJTA+Ey4iZQufuNGnyCkgx4UYpw@mail.gmail.com>
In-Reply-To: <CA+icZUXivDPEANKtrb+3Ux=YJTA+Ey4iZQufuNGnyCkgx4UYpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Sedat Dilek <sedat.dilek@googlemail.com>:

> On Sat, Jul 23, 2011 at 9:21 AM, Pavel Roskin <proski@gnu.org> wrote:
>> When checking for the band, use channel->band.
>>
>> Change ath5k_hw_nic_wakeup() and ath5k_channel_ok() to take
>> ieee80211_channel.  Change ath5k_hw_radio_revision() to take
>> ieee80211_band.
>>
>> Signed-off-by: Pavel Roskin <proski@gnu.org>
>>
>
> Tested on Atheros AR5212 chip against linux-next (next-20110722).
>
> Feel free to add:
>
>      Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

Thank you!  You testing is valuable and encouraging.

-- 
Regards,
Pavel Roskin
