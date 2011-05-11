Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41763 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1EKCLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 22:11:52 -0400
Received: by ywj3 with SMTP id 3so24536ywj.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 19:11:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DC9A557.9050405@candelatech.com>
References: <4DBF1967.9010604@candelatech.com>
	<BANLkTimYks_+QRUNURtbRy+S941fL04HRQ@mail.gmail.com>
	<4DC042A5.9050806@candelatech.com>
	<BANLkTikuw4uSOL5zoMa9QzOsajnSyhEsGQ@mail.gmail.com>
	<4DC17DAE.9020808@candelatech.com>
	<4DC47C04.1080604@candelatech.com>
	<4DC83B03.5070002@candelatech.com>
	<BANLkTimtRz8SMTRnn57CUgkudJ6=_vK+kw@mail.gmail.com>
	<4DC9A557.9050405@candelatech.com>
Date: Wed, 11 May 2011 10:11:51 +0800
Message-ID: <BANLkTin4_WmCn3hY6zUCWOkGCOzBZyR++A@mail.gmail.com> (sfid-20110511_041210_177102_63C9C7E1)
Subject: Re: Looking for 3x3 Atheros NICs using ath9k driver.
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unex make SR-71 NICs which are guaranteed to use the BC1 generation of
AR9160. They sell a normal and high powered dual-band version.

I've got both here and they both work remarkably well.

It's a shame we can't easily get to the bottom of what's going on, I'd
like to try and figure out what's going on with waking up these
atheros NICs on power-on. I'd hate for this to be the first indication
of a wider problem later on (especially if any Osprey's are detecting
as device 0xabcd, which from what I've been told shouldn't be
happening..)


Adrian
