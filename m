Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57139 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1GDUyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 16:54:45 -0400
Received: by iyb12 with SMTP id 12so4702171iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 13:54:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107042242.25197.chunkeey@googlemail.com>
References: <CAMJnVwmtNBrAbaL5TU-pQO+cvFn=UJC2rQroJeYASL3zJEesaw@mail.gmail.com>
	<201107042223.33968.chunkeey@googlemail.com>
	<CAMJnVwm0WE_T=GztegJaTp_kZttAQnWi_jgbXHk-S6HgP2OyKQ@mail.gmail.com>
	<201107042242.25197.chunkeey@googlemail.com>
Date: Mon, 4 Jul 2011 22:54:44 +0200
Message-ID: <CAMJnVwmsOeSSKVpzkihtxHziKsGv1nH5qhRitSRJHkTenvNiJg@mail.gmail.com> (sfid-20110704_225453_683671_49C74089)
Subject: Re: carl9170: Problems setting up Virtual Interface
From: Alex <alex9434@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, I will set hostapd to use the same channel as my router (my router
is on channel 3).
So I will use "channel=3" in hostapd.conf

What do I need to do to connect to the router with the virtual interface?

Any idea?

Thanks,
Alex


On Mon, Jul 4, 2011 at 10:42 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Monday, July 04, 2011 10:29:06 PM Alex wrote:
>> I am quite new to this and don't know how to bring this up to connect
>> to my router (with WPA2 encryption). ifup does not work:
>>
>> ifup wlan1-wlan0
>> Ignoring unknown interface wlan1-wlan0=wlan1-wlan0.
> be careful there.
> The device has only one radio and there's no channel manager.
> As soon as the station is up, it will start scanning and this
> takes the AP out-of-order...
>
