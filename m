Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:45741 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbZLHQCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 11:02:06 -0500
Received: by iwn1 with SMTP id 1so3835769iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 08:02:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0912080657s7cfccd4dp6525702e609bdd5f@mail.gmail.com>
References: <bf87febf0912030507u1c36f6a9h7cac0efabf3d016@mail.gmail.com>
	<20091204192315.GA5786@tuxdriver.com> <bf87febf0912070205k40a7286dpbb48cfcc494203d2@mail.gmail.com>
	<20091207215903.GC18939@tuxdriver.com> <b6c5339f0912080657s7cfccd4dp6525702e609bdd5f@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 8 Dec 2009 08:01:52 -0800
Message-ID: <43e72e890912080801s52607743s738ed6cdad7d154e@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: add support for Dell Vostro A860 LED
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Shahar Or <mightyiampresence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 8, 2009 at 6:57 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Mon, Dec 7, 2009 at 4:59 PM, John W. Linville <linville@tuxdriver.com> wrote:
>> On Mon, Dec 07, 2009 at 12:05:54PM +0200, Shahar Or wrote:
>>> Adds support for the WiFi activity LED on the Dell Vostro A860 laptop.
>>>
>>> Signed-off-by: Shahar Or <shahar@shahar-or.co.il>
>>> ---
>>> I hope this one is perfect.
>
> Thanks for the patch.  As for getting a better solution to LEDs, I
> trolled through the ACPI spec and code, and while various modules
> do set up LED pins, there doesn't seem to be a way to generally
> get that information from another module and it appears different
> between each vendor.  I am by no stretch expert in ACPI stuff
> though.
>
> Luis, I've asked this before but maybe you know better now or know
> whom to ask on your side.  Atheros must have a way on Windows to
> figure out the LED pin/polarity -- do you have any idea?  Ath9k
> uses the SREV but that seems to be insufficient for ath5k judging
> by all the quirks.

IIRC this is all mapped in the INF file, I thought I had released an
INF file under the ISC license but it seems that's not the case, I can
try to do that if it helps. Anyway, if we can move this sort of map to
userspace it'd be neat as you'd just need a userspace file update.
Only thing is how to do this in a generic way for all wireless drivers
and if this is indeed useful for other drivers.

  Luis
