Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44252 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab1COBxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 21:53:12 -0400
Received: by vws1 with SMTP id 1so146177vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 18:53:11 -0700 (PDT)
MIME-Version: 1.0
From: Chris Neugebauer <chrisjrn@gmail.com>
Date: Tue, 15 Mar 2011 12:52:51 +1100
Message-ID: <AANLkTinBTXduB-uQp7FqNjPdzUm5=0v8vrE79oi5Toez@mail.gmail.com>
Subject: Broadcom 4331 wireless device
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've recently picked up a MacBook Pro 8,1.  Its onboard wireless is a
Broadcom 4331, which appears to be a very new chipset.  Has work begun
on support for this device, and if not, what help can I provide to get
work started on it (as a non-kernel developerey type)?

Thanks,

--Chris

P.S. Please CC me as I'm not on this list.

P.P.S lspci -vnn output:

03:00.0 Network controller [0280]: Broadcom Corporation Device
[14e4:4331] (rev 02)
        Subsystem: Apple Computer Inc. Device [106b:00d6]
        Flags: bus master, fast devsel, latency 0, IRQ 11
        Memory at a0600000 (64-bit, non-prefetchable) [size=16K]



-- 
--Christopher Neugebauer

Jabber: chrisjrn@gmail.com -- IRC: chrisjrn on irc.freenode.net --
AIM: chrisjrn157 -- MSN: chris@neugebauer.id.au -- WWW:
http://chris.neugebauer.id.au -- Twitter/Identi.ca: @chrisjrn
