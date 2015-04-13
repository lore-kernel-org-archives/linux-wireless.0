Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36150 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbbDMBEW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Apr 2015 21:04:22 -0400
Received: by wgsk9 with SMTP id k9so65209824wgs.3
        for <linux-wireless@vger.kernel.org>; Sun, 12 Apr 2015 18:04:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <430726FF-98A3-4661-ACEE-87781CADD490@embarqmail.com>
References: <430726FF-98A3-4661-ACEE-87781CADD490@embarqmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 13 Apr 2015 11:04:00 +1000
Message-ID: <CAGRGNgUh-n8Grq94YgOAXGR8+hfMHGSx_tQVk6uQaHj9T_U-aQ@mail.gmail.com> (sfid-20150413_030425_694403_A8E11350)
Subject: Re: DRIVER FOR INTEL2200BG
To: "J.H. Schmidt" <sophiedoc@embarqmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Apr 13, 2015 at 10:39 AM, J.H. Schmidt <sophiedoc@embarqmail.com> wrote:
> My IBM(Lenovo) laptop running XP crashed a year ago and I changed to Lupuplus which
> runs on RAM.No problems with older Sprint modem and D link router running Wi Fi.Enter
> a nearby lightning strike which killed the router.Century link gave us a new modem router
> combo which works fine with with 2 computes r running 7 and 2 IMacs.I can't get the
> Linux machine to work with the new Century Link combo modem router-Any ideas?

I'm not sure I understand your problem.

1. You're running some RAM based Linux distro on your Thinkpad
2. It has an Intel 2200bg card
3. You've gotten a new router
4. Now it doesn't connect

If you were connecting to the old router using WiFi, your card is
already working.

I'm guessing your new router is much newer than the old one. Is it an
"n" router? (I.e. supports 802.11n, WiFi speeds above 54Mbit/s) Some
of them default to "n" only operation and need a setting turned on to
allow "b" or "g" devices to connect.

I'd investigate the settings of the router and ensure that
compatibility for older ("g") devices is turned on.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
