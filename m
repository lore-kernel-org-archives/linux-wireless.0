Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:18833 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbZAHXGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 18:06:13 -0500
Received: by fg-out-1718.google.com with SMTP id 19so3339724fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 15:06:11 -0800 (PST)
Message-ID: <3ace41890901081506r7e38328apee3007b556db0cd3@mail.gmail.com> (sfid-20090109_000619_165482_0F5F9431)
Date: Thu, 8 Jan 2009 23:06:11 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: lmage11@twcny.rr.com
Subject: Re: Help debugging unexpected disassociations?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090108224343.F9TJC.227705.root@hrndva-web20-z02>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081230013810.R86WV.401393.root@hrndva-web19-z02>
	 <20090108224343.F9TJC.227705.root@hrndva-web20-z02>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 8, 2009 at 10:43 PM,  <lmage11@twcny.rr.com> wrote:
> ---- lmage11@twcny.rr.com wrote:
>> Hey everyone. I'm using an Intel 4965AGN using the iwlagn
>> driver in 2.6.28. When using a specific AP, my connection is
>> unexpectedly dropping with nothing more than a
>> "wlan0: deauthenticated". Any tips on how I could figure out
>> whether this is the driver's fault or the AP's? Another problem I'm
>> having is that dhcpcd is timing out a lot, usually after trying to
>> reconnect from a connection drop.
>>
>> The AP is a Linksys WRT54Gv1 with WPA2 and ssid broadcasting enabled.
>>
>> Thanks!
>>
>> Ari
>
> Um... Bump?

It is no use and quite annoying to do that - it sounds like "read my
mind and spoon-feed me". Your initial post has almost no useful
information to speak of (actual log entries, wpa_supplicant config,
whether using networkmanager or static config, etc).

You probably should try to run wpa_suplicant in the foreground.
