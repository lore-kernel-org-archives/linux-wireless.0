Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35812 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab1LWHnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 02:43:16 -0500
Received: by qcqz2 with SMTP id z2so5436310qcq.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2011 23:43:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111222155415.GA13554@redhat.com>
References: <CAA=oPaiE-NAP_rfi3BLv-wM_wBwfLyMh-p2KtMALXPaDG6LxxA@mail.gmail.com>
	<20111222141102.GA2261@redhat.com>
	<CAA=oPajYJQoz0AhAaGuY9y=2gbMUfpBZJU71TmryG_zksQk_Nw@mail.gmail.com>
	<20111222155415.GA13554@redhat.com>
Date: Fri, 23 Dec 2011 08:43:15 +0100
Message-ID: <CAA=oPajknLLXAK7xQhkoK+YhtQhE1M8fworNkhEW+yZYTmN6+w@mail.gmail.com> (sfid-20111223_084334_444502_38788C2A)
Subject: Re: rt2800usb poor performance
From: Christian Frost <cf@cfrost.dk>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I get the following print outs:

Compat-wireless backport release:
compat-wireless-v3.2-rc6-3Backportbased on linux-stable.git
v3.2-rc6cfg80211: Calling CRDA to updateworld regulatory domainusb
2-1: reset high speed USB device usingehci_hcd and address 2phy0 ->
rt2x00_set_chip: Info - Chipset detected- rt: 3070, rf: 0005, rev:
0201.

Please let me know if you need for info.
On Thu, Dec 22, 2011 at 4:54 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Dec 22, 2011 at 03:42:00PM +0100, Christian Frost wrote:
>> Yes, I have tried all your suggestions and they do not help. I
>> havedownloaded the firmware from ralinktech in version v2.4.0.1
>
> If you compile driver with CONFIG_RT2X00_DEBUG it will show exact
> chip name. Please provide that info, we probably need to fix
> that chip support in rt2800usb. For now you will need to use vendor
> driver, which unfortunately will most likely work better than in kernel
> driver for that particular chip.
>
> Stanislaw
