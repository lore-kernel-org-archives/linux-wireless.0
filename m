Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52878 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1AVPok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jan 2011 10:44:40 -0500
Received: by qyk12 with SMTP id 12so2979570qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jan 2011 07:44:39 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D3AEE9C.4060306@googlemail.com>
References: <4D3AEE9C.4060306@googlemail.com>
Date: Sat, 22 Jan 2011 16:44:38 +0100
Message-ID: <AANLkTi=N9OQMCKZFUkE3Tgmfx0bDEe1QC6ooEpZKqvrg@mail.gmail.com>
Subject: Re: The future of ACX100/ACX111/TNETW1450 support in the kernel?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Kassandra Drowner <kassandra.drow@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 22, 2011 at 3:50 PM, Kassandra Drowner
<kassandra.drow@googlemail.com> wrote:
> I'm using a AVM Fritz Wlan Stick of the first generation. This USB device
> has the TNETW1450 by Texas Instruments.
> According to the ubuntu-wikipage this is one device that needs to be handled
> with ndiswrapper & the windows driver , because no kernel driver is
> available.
>
> I searched around and came across http://acx100.sourceforge.net/ . This
> driver isnt merged obviously because of legal problems with the developing
> process.
>
> In the LWN Article "Who wrote 2.6.37" ( http://lwn.net/Articles/420658/ )
> i've seen the chipset manufacturer Texas instruments being ranked quite high
> up.
>
> Are there plans to get official support for the chipsets
> ACX100/ACX111/TNETW1450 in the mainline tree one day, now that the
> manufacturer has started to work on linux-support? Will the legal issues be
> dealt with, so the sf-project can be included and the driver being worked on
> by more people than just 2 or 3 ?
>
>
> Kassandra Drowner
>

JFYI: OpenWRT is maintaining acx-mac80211 (could not test on my
Speedport-W701/AR7-router-plattform yet, using freetz).

- Sedat -

[1] https://dev.openwrt.org/browser/trunk/package/acx-mac80211
[2] http://acx100.git.sourceforge.net/git/gitweb.cgi?p=acx100/acx-mac80211;a=summary
