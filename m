Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.182]:12683 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbYEJS43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 14:56:29 -0400
Received: by el-out-1112.google.com with SMTP id s27so417599ele.1
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 11:56:28 -0700 (PDT)
Message-ID: <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com> (sfid-20080510_205650_857219_83A45649)
Date: Sat, 10 May 2008 21:56:27 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Vincent C Jones" <v.jones@networkingunlimited.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies - 2.6.26-rc1 kernel
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091423y680b6706ta124eaaed73c81c0@mail.gmail.com>
	 <1210376474.3856.7.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
	 <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
	 <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> May be more to this than just missing 802.11a channel reporting...
> walked to within range of a NetGear dual-band 802.11N 5GHz/11G 2.4GHz AP
> and could not even see the 802.11A side of the AP, (while another
> machine was associated with it, so both halves of the AP were up).
> I associated on the G channel, then tried to force an association on the
> A channel by setting the frequency with iwconfig. At some point, I got
> the following (note that I could still associate with the G channel when
> done):
>
> ay 10 11:20:04 X61 kernel: ------------[ cut here ]------------
> May 10 11:20:04 X61 kernel: WARNING: at
> include/../net/mac80211/rate.h:153 rs_get_rate+0x159/0x194 [iwl4965]()

Something went wrong with station management.  Do you use same BSSID
on the both interfaces A and G?

Thanks
Tomas
