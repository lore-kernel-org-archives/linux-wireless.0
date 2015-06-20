Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34798 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbbFTUBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2015 16:01:37 -0400
Received: by lbbti3 with SMTP id ti3so88965987lbb.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 Jun 2015 13:01:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5585B209.3040406@gmail.com>
References: <5585B209.3040406@gmail.com>
Date: Sat, 20 Jun 2015 23:01:36 +0300
Message-ID: <CANUX_P0DYFVqxVHg6B8ZXLiLv97Gu8JuiXcUEA8rvPMW8+Jb2Q@mail.gmail.com> (sfid-20150620_220143_101639_0EF60217)
Subject: Re: "No association and the time event is over already..."
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Blue Glacier <blueglacier414@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 20, 2015 at 9:33 PM, Blue Glacier <blueglacier414@gmail.com> wrote:
> Hello,
>
> my Intel Wireless 7265 chip suddenly stopped working. The Network Manager
> shows that I am connected, but I cannot even ping to my home router. I
> didn't change anything on my system.

What is your AP? Can you reproduce consistently? If you disable WiFi
and re-enable WiFi from the Network Manager, does it help?

>
> The output of dmesg looks interesting:
>
> [  507.737606] wlan0: Connection to AP c0:25:06:ce:d2:e9 lost
> [  507.806070] cfg80211: Calling CRDA for country: DE
> [  508.379770] cfg80211: Calling CRDA for country: DE
> [  511.332818] wlan0: authenticate with c0:25:06:ce:d2:e9
> [  511.338625] wlan0: send auth to c0:25:06:ce:d2:e9 (try 1/3)
> [  511.341600] wlan0: authenticated
> [  511.343813] wlan0: associate with c0:25:06:ce:d2:e9 (try 1/3)
> [  511.350128] wlan0: RX AssocResp from c0:25:06:ce:d2:e9 (capab=0x431
> status=0 aid=8)
> [  511.353700] wlan0: associated
> [  511.645582] iwlwifi 0000:03:00.0: No association and the time event is
> over already...
> [  511.645642] wlan0: Connection to AP c0:25:06:ce:d2:e9 lost
> [  511.688174] cfg80211: Calling CRDA to update world regulatory domain
>
> (repeated numerous times)
>
> I am using Debian 8 Jessie (stable) together with the firmware from your
> server (iwlwifi-7265-9.ucode). The Kernel Version is 3.16.0-4-amd64.

Can you try a more recent kernel with a more recent firmware?
You can check https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/core_release
if you want to update your driver without changing your kernel.

>
> Any idea how to fix this?


>
> Jens
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
