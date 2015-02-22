Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:41918 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbbBVVuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 16:50:18 -0500
Received: by mail-ig0-f177.google.com with SMTP id z20so14217711igj.4
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 13:50:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
	<CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
	<CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
	<CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
Date: Sun, 22 Feb 2015 13:50:16 -0800
Message-ID: <CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com> (sfid-20150222_225022_139490_F3E0DA32)
Subject: Re: AR9462 problems connecting again..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 22, 2015 at 11:39 AM, Adrian Chadd <adrian@freebsd.org> wrote:
>
> Hm, can you enable wpa debugging to log everything whilst it's
> associating / reassociating?

Ugh. When I add "-dd" to the command line, it has now worked three
times in a row, when before it worked once out of ten tries.

So my guess is that it's something timing-dependent.

Or it's something where once it starts working, it stays working until
I reboot. I'll try that.

                         Linus
