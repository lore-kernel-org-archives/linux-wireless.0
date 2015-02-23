Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:60158 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbBWB7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 20:59:04 -0500
Received: by mail-ig0-f170.google.com with SMTP id l13so18102512iga.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 17:59:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmomz+hydAPGJ2gQcbqBC6uxY=aMRuysyMB-Z9CFL8SY81A@mail.gmail.com>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
	<CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
	<CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
	<CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
	<CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
	<CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
	<CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
	<CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
	<CAJ-Vmomz+hydAPGJ2gQcbqBC6uxY=aMRuysyMB-Z9CFL8SY81A@mail.gmail.com>
Date: Sun, 22 Feb 2015 17:59:02 -0800
Message-ID: <CA+55aFzrRhAtX_XeuN86zqFxbKotZQKOWLvUg3AyCfP+a3gNvw@mail.gmail.com> (sfid-20150223_025907_740237_6E823126)
Subject: Re: AR9462 problems connecting again..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 22, 2015 at 5:55 PM, Adrian Chadd <adrian@freebsd.org> wrote:
>
> Do you have a 5GHz SSID setup on this access point? Is this kind of
> messed up diassociation-to-steer-you-to-another-band thing?

Nope. That's the older single-band UniFi UAP - 2.4GHz only.

                       Linus
