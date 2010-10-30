Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54919 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab0J3EGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Oct 2010 00:06:17 -0400
Received: by ywc21 with SMTP id 21so2042ywc.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 21:06:16 -0700 (PDT)
Message-ID: <4CCB99CB.9000400@lwfinger.net>
Date: Fri, 29 Oct 2010 23:06:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Walter Goldens <goldenstranger@yahoo.com>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Realtek rtl8188 support?
References: <201010292202.25486.s.L-H@gmx.de> <694082.86488.qm@web56803.mail.re3.yahoo.com> <AANLkTimnuHM3E3G=d+R4-b=1NDkdEQ9jkbQsqB9ASiEC@mail.gmail.com>
In-Reply-To: <AANLkTimnuHM3E3G=d+R4-b=1NDkdEQ9jkbQsqB9ASiEC@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/29/2010 04:27 PM, Gábor Stefanik wrote:
> 
> AFAIK we only add staging drivers that will eventually move out of
> staging. r8712 has no chance of ever leaving staging; a completely new
> driver needs to be written (because it isn't mac80211-based).

That is correct, but it should not be too long until there is a mac80211 driver
for that chip. I just got GPLd sources from Realtek for a mac80211-based driver
for the RTL8192CE PCIe device. It will need only a small amount of work to make
it ready for mainline. The critical part is that it uses the same chip as is
used in the RTL8712 USB device.

For those that are interested in the RTL8187SE, I'm told that they have a
working mac80211 driver for it, but that it is not yet stable.

Larry

