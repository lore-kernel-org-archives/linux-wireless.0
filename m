Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36624 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbcDZK0U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 06:26:20 -0400
Received: by mail-io0-f194.google.com with SMTP id k129so1493650iof.3
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 03:26:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461664802.16188.8.camel@sipsolutions.net>
References: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
	<CAAA5faGpa9ePaZagPpNaXdXz8FZrsDr=M4pMGEVO6F3xUc+aZA@mail.gmail.com>
	<1461664802.16188.8.camel@sipsolutions.net>
Date: Tue, 26 Apr 2016 11:26:19 +0100
Message-ID: <CAL3+40ExBLbSqJekDndBZkAsNf0pp5rTCga+SSujnsP9To4U=A@mail.gmail.com> (sfid-20160426_122624_781227_93A48C4F)
Subject: Re: Intel 7260 AC only using 802.11n not AC
From: Radu P <rrrpan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Reinoud Koornstra <reinoudkoornstra@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iw list|grep -i VHT  <- still nothing

iw dev wlanX link
Connected to *.* (on wlan1)
SSID: *****
freq: 2432
RX: 45056569 bytes (38259 packets)
TX: 5239816 bytes (27324 packets)
signal: -54 dBm
tx bitrate: 144.4 MBit/s MCS 15 short GIc0:3e:0f:d6:54:b9

bss flags: short-preamble short-slot-time
dtim period: 1
beacon int: 100

On Tue, Apr 26, 2016 at 11:00 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2016-04-26 at 02:56 -0600, Reinoud Koornstra wrote:
>> I'm also using the 7620 AC.
>> When I type:
>>
>> sudo iw dev wlp0s4 scan I see:
>>
>
> "scan" is completely irrelevant for what actually ends up getting used.
> "link" is relevant, but if you want to see the hardware capabilities
> (like what iwconfig is displaying - that field has no relation to the
> connection at all) then you need "iw list" or so.
>
> johannes
