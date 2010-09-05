Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48433 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab0IEXGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Sep 2010 19:06:46 -0400
Received: by iwn5 with SMTP id 5so3631357iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Sep 2010 16:06:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinu_4tsfJ=0CXS7yuuiqw0X5juqjP_T_edw0b4Y@mail.gmail.com>
References: <AANLkTim_Ou8fFbfsn8AEZFpWBzjnAQuT4S_w8bV5saYD@mail.gmail.com>
	<loom.20100903T224155-155@post.gmane.org>
	<AANLkTikdXBsO0Qx2nEV+Ka9X2D55odmGwePMaUGaQi7j@mail.gmail.com>
	<AANLkTinu_4tsfJ=0CXS7yuuiqw0X5juqjP_T_edw0b4Y@mail.gmail.com>
Date: Mon, 6 Sep 2010 01:06:45 +0200
Message-ID: <AANLkTi=aJssChg0uiEec-Pa=3oOdc3cFoee1X7U7BWwF@mail.gmail.com>
Subject: Re: mac80211-based commercial router?
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, jpo <pommnitz@yahoo.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/6 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Sun, Sep 5, 2010 at 10:08 PM, Bob Copeland <me@bobcopeland.com> wrote:
>> On Fri, Sep 3, 2010 at 4:43 PM, jpo <pommnitz@yahoo.com> wrote:
>>
>>> Android 2.2 comes with AP functionality. Are the Android WLAN drivers mac80211
>>> based?
>>
>> No, they aren't.  Does Android really do AP mode or
>> just adhoc?
>>
>> wl1251 is an in-tree module for the TI chip used in G1,
>> but it doesn't support AP mode.  I do not know if there's
>> a mac80211 driver that supports the broadcom chip used
>> in other phones.
>
> AFAIK BCM4325 should be doable, especially if it is attached via SDIO
> bus. In phones where SPI is used, it is more problematic, as b43
> doesn't support SPI.
>

I guess the short answer is no then; all the chip vendors still focus
on their own proprietary mac implementations, at least on the AP side.
Any thoughts on what would be required for them to switch to mac80211?
Will it ever happen?

/Björn
