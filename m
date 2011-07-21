Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:34692 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab1GUOPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 10:15:08 -0400
Received: by fxd18 with SMTP id 18so3643792fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 07:15:06 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislav Demakov <s.demakov@gmail.com>
Subject: Re: rt2x00, AP mode, 802.11n is not working properly
Date: Thu, 21 Jul 2011 16:13:01 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <CAN=pzdLRaRHkg4NquUpDhEwRzq-roKQXMtMcwnr031maDSLRfw@mail.gmail.com> <CAGXE3d9HgRvdJModc3hSA25+jLktZJ3i997oq7GfZz4dUJfuvw@mail.gmail.com> <CAN=pzdKHWNcvwAn3uDMzTdpvv3MkM9KNC89NuzZX=z6npBnUGg@mail.gmail.com>
In-Reply-To: <CAN=pzdKHWNcvwAn3uDMzTdpvv3MkM9KNC89NuzZX=z6npBnUGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201107211613.01938.helmut.schaa@googlemail.com> (sfid-20110721_161513_179016_C1DA7EAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 21. Juli 2011 schrieb Stanislav Demakov:
> This patch won't apply on current compat-wireless-2011-07-20.tar.bz2
> 
> (Stripping trailing CRs from patch.)
> patching file b/drivers/net/wireless/rt2x00/rt2800lib.c
> Hunk #1 FAILED at 4194.
> 1 out of 1 hunk FAILED -- saving rejects to file
> b/drivers/net/wireless/rt2x00/rt2800lib.c.rej
> (Stripping trailing CRs from patch.)
> patching file b/drivers/net/wireless/rt2x00/rt2800usb.c
> Hunk #1 FAILED at 527.
> patch unexpectedly ends in middle of line
> Hunk #2 FAILED at 820.
> 2 out of 2 hunks FAILED -- saving rejects to file
> b/drivers/net/wireless/rt2x00/rt2800usb.c.rej
> 
> Should I use another version of compat wireless or edit files manually?

Just edit manually, it's not much ...

> Also I have no stability issues, the connection is stable, but as I
> said the TX speed from AP running rt2x00 (the driver is in Master
> mode) to client is extremely slow in 802.11n+WMM mode.

Yeah, understood. That's what I saw in STA mode as well. Now I get a stable
transmit speed >20Mbps (MCS7 20Mhz).

> And this is only WMM mode related, because wIthout it everything is fine.

Disabling WMM might force some clients to disable 11n, not sure though how
this relates.

Helmut
