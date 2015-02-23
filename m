Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:32933 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbBWBzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 20:55:06 -0500
Received: by iecar1 with SMTP id ar1so20181530iec.0
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 17:55:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
	<CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
	<CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
	<CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
	<CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
	<CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
	<CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
	<CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
Date: Sun, 22 Feb 2015 17:55:04 -0800
Message-ID: <CAJ-Vmomz+hydAPGJ2gQcbqBC6uxY=aMRuysyMB-Z9CFL8SY81A@mail.gmail.com> (sfid-20150223_025511_926616_182C8A5C)
Subject: Re: AR9462 problems connecting again..
From: Adrian Chadd <adrian@freebsd.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 February 2015 at 17:41, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Feb 22, 2015 at 4:54 PM, Adrian Chadd <adrian@freebsd.org> wrote:
>>
>> I /think/ it's okay? The removed stuff is the pre-shared key pieces.
>
> Ok. Attached is what seems to be the relevant part of the
> wpa_supplicant.log file.
>
> The datestamp has been changed so that it can be matched up with the
> dmesg, and I added empty lines for pauses when I was trying to figure
> out what the heck it was doing, but other than that it's the raw log.
>
>> Do you have another laptop with an atheros NIC in it that you could
>> use in monitor mode to capture all the frames?
>
> Nope, everything else I have seems to be intel wireless. I think one
> of the kids machines is a Mac Mini with an ath5k thing, but I'm hoping
> the wpa_supplicant.log is sufficient to give somebody an idea.

Do you have a 5GHz SSID setup on this access point? Is this kind of
messed up diassociation-to-steer-you-to-another-band thing?




-adrian
