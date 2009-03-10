Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:13647 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbZCJVEW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 17:04:22 -0400
Received: by fk-out-0910.google.com with SMTP id f33so780933fkf.5
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 14:04:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090306084527.5a3b6300.cjsthompson@gmail.com>
References: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com>
	 <4dd58f490903041333y4e2abe8r72204232ec4a65ac@mail.gmail.com>
	 <20090304232625.cc47eb46.cjsthompson@gmail.com>
	 <4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com>
	 <20090304232527.058017da.cjsthompson@gmail.com>
	 <4dd58f490903051449h3b2eb96ay5d83d7ea8129370f@mail.gmail.com>
	 <20090306084527.5a3b6300.cjsthompson@gmail.com>
Date: Tue, 10 Mar 2009 21:04:17 +0000
Message-ID: <4dd58f490903101404m3678728ag13735851e232a8f4@mail.gmail.com> (sfid-20090310_220425_572271_AE791602)
Subject: Re: ath5k master (AP) mode
From: Alexey Yudichev <ayudichev@yahoo.co.uk>
To: "Christoph J. Thompson" <cjsthompson@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> On Thu, 5 Mar 2009 22:49:16 +0000
> Alexey Yudichev <ayudichev@yahoo.co.uk> wrote:
> > Thanks Christoph, looks like ubuntu is currently at 2.6.28 and I do
> > not want to attempt installing non-ubuntu-patched kernel. Also, what
> > is the driver option value in your hostapd config? Is it nl80211? And
> > last question, do you know anything about that "another" patch for pre
> > 2.6.29 kernels?
>
> Hi,
>
> Yes, the driver option value is nl80211. This is the patch you are looking for I think:
>
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/030-allow-ap-vlan-modes.patch
>
>
> --
> Christoph J. Thompson <cjsthompson@gmail.com>

Thanks. This link is broken however simple search brings me here:
http://wireless.erley.org/
where the author says that Atheros AR5213A does not work: "Lets me set
master mode, and activate hostapd, but not found on other machines
while scanning". Well what I tried is I left the kernel on 2.6.27-13,
compiled latest compat-wireless, upgraded to hostapd 0.6.8 and I got
hostapd starting successfully. I configured it for open system and got
my Windows Mobile 5 PDA connecting to it successfully and even
interenet was working! WM6 Smartphone connects from 2nd or 3rd attempt
but has no access to internet for some reason. With WPA2-PSK WM6
connects but still no internet and WM5 does not connect even though
the config is pretty standard:
wpa=3
wpa_passphrase=abcdefgh
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP

Does this resemble your wpa configuration?

Do you know, if I got this far, can unstable connection and not
working WPA be related to older kernel?
What clients did you try? I can't understand why internet access works
on WM5 but not on WM6. Both devices worked great with hardware
wireless router.
