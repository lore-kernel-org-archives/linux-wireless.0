Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:57672 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbbBVS6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 13:58:39 -0500
Received: by mail-ob0-f173.google.com with SMTP id uy5so32982666obc.4
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 10:58:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
	<CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
	<CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
Date: Sun, 22 Feb 2015 10:58:38 -0800
Message-ID: <CAA93jw4yckBgpoBf_ysDd2s8rJ5HKgx7VoTP9tnkPeSt6jn_2w@mail.gmail.com> (sfid-20150222_200125_977653_2485ABD8)
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
From: Dave Taht <dave.taht@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 22, 2015 at 10:30 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Feb 22, 2015 at 10:24 AM, Adrian Chadd <adrian@freebsd.org> wrote:
>>
>> Just a wild shot - try disabling fast authentication and see if that
>> makes a difference?
>>
>> wpa_supplicant.conf:
>>
>> fast_reauth=0
>>
>> I recall having issues with fast_reauth once, but I never stuck around
>> that location long enough to debug it.
>
> Nope. Did that, killed wpa_supplicant (which restarts it), tried
> connecting, still failed.

Hint: Several unifi (and most ubnt) products are well supported by
openwrt directly, which by reflashing your device to it via their web
interface would

A) probably fix the problem, and
B) give you more insight into fixing it, if it persists, by giving you
full access on both sides of the connection.

https://downloads.openwrt.org/snapshots/trunk/ar71xx/generic/

I have been replacing ubnt´s default firmware on first boot for 6+
years now. It is good hardware, after you do that.

-- 
Dave Täht

http://www.bufferbloat.net/projects/cerowrt/wiki
