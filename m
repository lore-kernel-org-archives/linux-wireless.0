Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44281 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaKYOOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 09:14:00 -0500
Received: by mail-pd0-f170.google.com with SMTP id fp1so663302pdb.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2014 06:13:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416917279.2045.5.camel@sipsolutions.net>
References: <1416911009-22405-1-git-send-email-johannes@sipsolutions.net>
	<CAFuUQkh-fX3rz9+FUBfF8GxbkxrZxP7-iJwmypo5EEANwODqzQ@mail.gmail.com>
	<1416913453.2045.4.camel@sipsolutions.net>
	<CAFuUQkhuUDVcfv-pxLkhNT7C2TOqOS4nh+3qDj0uFV3OpoAS5w@mail.gmail.com>
	<1416917279.2045.5.camel@sipsolutions.net>
Date: Tue, 25 Nov 2014 22:13:59 +0800
Message-ID: <CAFuUQkiXfYf1s4UJyvtFT9Jsh=Dd_1vYH6XiJ0B5iSfRxWA8dQ@mail.gmail.com> (sfid-20141125_151404_296669_01357DC1)
Subject: Re: [PATCH] mac80211: check if channels allow 80 MHz for VHT probe requests
From: YanBo <dreamfly281@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2014 at 8:07 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2014-11-25 at 19:10 +0800, YanBo wrote:
>
>> We already start the working to support the VHT modulations MCS8 and
>> MCS9 support in 2.4G for ath10k  devices,
>> and it used the band->vht_cap = vht_cap to notification the mac80211,
>> if we band it with 80MHz, it is do need another
>> new advertisement for this as your said.
>
> But is all of that really the right way? I'm not completely convinced.

Except set the flag, the HW itself should support this feature, or
else it also doesn't work, I'd
send the patch in soon for public review.

>
> I guess we can make this check conditional for 5GHz when the VHT support
> lands and is discussed.
>
That is sounds good if it only check for 5GHz for what I know CMIIW.

Thanks
BR /Yanbo
