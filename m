Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:28102 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbZAIVI7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 16:08:59 -0500
Received: by fg-out-1718.google.com with SMTP id 19so3523743fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 13:08:57 -0800 (PST)
Message-ID: <3ace41890901091308g7c9f5e2cj5595017131b7afd7@mail.gmail.com> (sfid-20090109_220905_969399_6962BC45)
Date: Fri, 9 Jan 2009 21:08:57 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: lmage11@twcny.rr.com
Subject: Re: Help debugging unexpected disassociations?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090108231828.QHGIG.228066.root@hrndva-web20-z02>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <3ace41890901081506r7e38328apee3007b556db0cd3@mail.gmail.com>
	 <20090108231828.QHGIG.228066.root@hrndva-web20-z02>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 8, 2009 at 11:18 PM,  <lmage11@twcny.rr.com> wrote:
> ---- Hin-Tak Leung <hintak.leung@gmail.com> wrote:
>> On Thu, Jan 8, 2009 at 10:43 PM,  <lmage11@twcny.rr.com> wrote:
>> > ---- lmage11@twcny.rr.com wrote:
>> >> Hey everyone. I'm using an Intel 4965AGN using the iwlagn
>> >> driver in 2.6.28. When using a specific AP, my connection is
>> >> unexpectedly dropping with nothing more than a
>> >> "wlan0: deauthenticated". Any tips on how I could figure out
>> >> whether this is the driver's fault or the AP's? Another problem I'm
>> >> having is that dhcpcd is timing out a lot, usually after trying to
>> >> reconnect from a connection drop.
>> >>
>> >> The AP is a Linksys WRT54Gv1 with WPA2 and ssid broadcasting enabled.
>> >>
>> >> Thanks!
>> >>
>> >> Ari
>> >
>> > Um... Bump?
>>
>> It is no use and quite annoying to do that - it sounds like "read my
>> mind and spoon-feed me". Your initial post has almost no useful
>> information to speak of (actual log entries, wpa_supplicant config,
>> whether using networkmanager or static config, etc).
>
> Um.
>
> Well considering as I'm not a developer and don't know how to debug
> these things, I think "spoon-feeding" is an appropriate term, no? And
> also, I didn't ask you to read my mind, I didn't even ask you to figure
> out the problem for me, I asked for the information that I would need
> to figure out the problem MYSELF.
>
> As for "useful information", the "wlan0: deauthenticated" is *LITERALLY*
> all I get. I was not lying to you. After stripping out identifying information,
> my wpa_supplicant config would be pretty much completely empty. The config
> for this AP is about as simple as a consumer WPA2 AP config can be. I am not
> using networkmanager.
>
>> You probably should try to run wpa_suplicant in the foreground.
>
> You mean so I can see the debug messages it outputs?

Even if you strip away privacy info (and put in xx.yy.zz) it is still
better than "read my mind and guess my problem".

For example, this is how my deauth looks like, when NetworkManager
cuts the connectiion, in preparation for
suspending to RAM:

wlan2: deauthenticating by local choice (reason=3)

Also, it is always useful to quote versions of relevant software -
what version of wpa_supplicant, and networkmanager you are using; or
even what distribution you are using, and hardware (64-bit, 32-bit).
You have written 3 times and added no new info.
