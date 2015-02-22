Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:44195 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbbBVVpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 16:45:08 -0500
Received: by iecar1 with SMTP id ar1so19256550iec.11
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 13:45:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA93jw4yckBgpoBf_ysDd2s8rJ5HKgx7VoTP9tnkPeSt6jn_2w@mail.gmail.com>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
	<CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
	<CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
	<CAA93jw4yckBgpoBf_ysDd2s8rJ5HKgx7VoTP9tnkPeSt6jn_2w@mail.gmail.com>
Date: Sun, 22 Feb 2015 13:45:07 -0800
Message-ID: <CA+55aFxeuR2PidybZa-YBnqFW541AZ_vFkwvBXqL61OB-JxRew@mail.gmail.com> (sfid-20150222_224512_481134_C1DE1BFF)
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Taht <dave.taht@gmail.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 22, 2015 at 10:58 AM, Dave Taht <dave.taht@gmail.com> wrote:
>
> Hint: Several unifi (and most ubnt) products are well supported by
> openwrt directly,

I want Linux to "just work". None of this "oh, you can change
something else and it probably works".  I want to fix the problem in
*linux*.

There's clearly something wrong with the AR9462 driver and/or how it
uses the wireless infrastructure, and it should be fixed. Not worked
around with "use some other AP software".

Especially since this has happened before.

Besides, the reason I'm trying to use UniFi is because I want to have
seamless roaming ("zero-handoff"). And I do *not* want to play the
endless openwrt configuration games in the hopes I can get something
like that working. I've tried openwrt, and I don't like tinkering with
my AP's. I just want things to work out of the box.

                          Linus
