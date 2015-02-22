Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:58030 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbbBVTj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 14:39:59 -0500
Received: by mail-ig0-f178.google.com with SMTP id hl2so13907482igb.5
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 11:39:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
	<CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
	<CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
Date: Sun, 22 Feb 2015 11:39:58 -0800
Message-ID: <CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com> (sfid-20150222_204002_535240_57C11244)
Subject: Re: AR9462 problems connecting again..
From: Adrian Chadd <adrian@freebsd.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 February 2015 at 10:30, Linus Torvalds
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

Hm, can you enable wpa debugging to log everything whilst it's
associating / reassociating?

(maybe log_devel debug? I tend to run wpa_supplicant at the command
line with debugging enabled, rather than doing it after-the-fact.)




-adrian
