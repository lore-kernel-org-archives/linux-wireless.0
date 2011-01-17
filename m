Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53384 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab1AQU1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 15:27:17 -0500
Received: by iyj18 with SMTP id 18so5006626iyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 12:27:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D34A421.3070804@lwfinger.net>
References: <4D34A421.3070804@lwfinger.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, 17 Jan 2011 12:26:56 -0800
Message-ID: <AANLkTin_DESckMrOMK41z3oJtXwmHvL026Mi8ayLeKLA@mail.gmail.com>
Subject: Re: Logs spammed by associate / authenticate / CRDA calls
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 17, 2011 at 12:18 PM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> The MAC address for the device is 00:1F:1F:C8:8E:CB and that of the AP is
> C0:3F:0E:BE:2B:45, thus corresponding with the above output.
>
> Is scanning this often normal? I suspect it is, but I have not looged the events
> before.
>
> Although both AP and STA support 802.11n, the connection is 802.11g (max 54
> Mbps) using WPA2-PSK.
>
> What triggers the "Disassociated due to inactivity"?

Scanning happens every time you associate/re-associate; disassociation
due to inactivity happens when your device doesn't send packets to the
AP for some period of time.  It looks like your AP's (or device's)
timeout is 100s.

Dan
