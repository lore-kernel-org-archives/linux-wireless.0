Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:54985 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbZCJVld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 17:41:33 -0400
Received: by ewy25 with SMTP id 25so1443393ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 14:41:30 -0700 (PDT)
Date: Tue, 10 Mar 2009 22:37:57 +0100
From: "Christoph .J Thompson" <cjsthompson@gmail.com>
To: Alexey Yudichev <ayudichev@yahoo.co.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k master (AP) mode
Message-Id: <20090310223757.a8618b61.cjsthompson@gmail.com> (sfid-20090310_224145_184881_6B540777)
In-Reply-To: <4dd58f490903101404m3678728ag13735851e232a8f4@mail.gmail.com>
References: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com>
	<4dd58f490903041333y4e2abe8r72204232ec4a65ac@mail.gmail.com>
	<20090304232625.cc47eb46.cjsthompson@gmail.com>
	<4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com>
	<20090304232527.058017da.cjsthompson@gmail.com>
	<4dd58f490903051449h3b2eb96ay5d83d7ea8129370f@mail.gmail.com>
	<20090306084527.5a3b6300.cjsthompson@gmail.com>
	<4dd58f490903101404m3678728ag13735851e232a8f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 10 Mar 2009 21:04:17 +0000
Alexey Yudichev <ayudichev@yahoo.co.uk> wrote:
> Thanks. This link is broken however simple search brings me here:
> http://wireless.erley.org/
> where the author says that Atheros AR5213A does not work: "Lets me set
> master mode, and activate hostapd, but not found on other machines
> while scanning". Well what I tried is I left the kernel on 2.6.27-13,
> compiled latest compat-wireless, upgraded to hostapd 0.6.8 and I got
> hostapd starting successfully. I configured it for open system and got
> my Windows Mobile 5 PDA connecting to it successfully and even
> interenet was working! WM6 Smartphone connects from 2nd or 3rd attempt
> but has no access to internet for some reason. With WPA2-PSK WM6
> connects but still no internet and WM5 does not connect even though
> the config is pretty standard:
> wpa=3
> wpa_passphrase=abcdefgh
> wpa_key_mgmt=WPA-PSK
> wpa_pairwise=TKIP CCMP
> 
> Does this resemble your wpa configuration?

I didn't try WPA yet but I will shortly.

> Do you know, if I got this far, can unstable connection and not
> working WPA be related to older kernel?

I can't be sure. I don't have the unstable connection problem but I didn't
use WPA yet. So maybe the unstable connection problem only happens with WPA.

> What clients did you try? I can't understand why internet access works
> on WM5 but not on WM6. Both devices worked great with hardware
> wireless router.

The client was Linux 2.6.29-rc6 with a USB WiFi key with the rtl8187L chipset.

-- 
Christoph .J Thompson <cjsthompson@gmail.com>
