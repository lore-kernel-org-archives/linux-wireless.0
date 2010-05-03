Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:53623 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab0ECVja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 17:39:30 -0400
Received: by pzk42 with SMTP id 42so394957pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 14:39:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BDC719E.3060505@dlasys.net>
References: <4BDC001F.9050202@dlasys.net> <201005011919.32016.chunkeey@googlemail.com>
	<4BDC719E.3060505@dlasys.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 3 May 2010 14:39:09 -0700
Message-ID: <l2l43e72e891005031439k261715c3rd453a38b68b44c92@mail.gmail.com>
Subject: Re: ar9170-fw II
To: "David H. Lynch Jr." <dhlii@dlasys.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 1, 2010 at 11:23 AM, David H. Lynch Jr. <dhlii@dlasys.net> wrote:
> On 05/01/2010 01:19 PM, Christian Lamparter wrote:
>>
>> Well, for starters the ar9170 uses a ZyDas MAC (aka ZD1221)
>> and a AR900x PHY/Radio. Therefore the phy code and registers
>> are very similar to those #definitions you can find in ath9k.
>> And for the MAC code&  registers you can look into zd1211rw,
>> or look into drivers/staging/otus (original vendor driver,
>> shares some code with their windows drivers)
>>
>> AFAICT, there are no technical documents about the AR9170
>> solution available w/o signing a NDA with Atheros
>> (probably because the devices are still produced and sold in high
>> quantities?).
>>
>
>    Thanks;
>        I did just discover a reasonably good 150p spec. in what I received
> from my client. If I can I will share it. I am under an NDA, but the client also told
> me that they received no cooperation from atheros.

You should be more specific. Atheros did GPL their ar9170 driver after
all, so it is in fact the first hardware vendor to ever have GPL'd
firmware for *any* device driver upstream. Releasing more docs takes
time, you are better off working directly with the upstream Atheros
developers than just subjectively claiming lack of cooperation.

  Luis
