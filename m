Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35260 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab0CBWaG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 17:30:06 -0500
From: Michael Buesch <mb@bu3sch.de>
To: William Bourque <william.bourque@polymtl.ca>
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
Date: Tue, 2 Mar 2010 23:29:58 +0100
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com> <201003022257.51878.mb@bu3sch.de> <4B8D906C.9020102@polymtl.ca>
In-Reply-To: <4B8D906C.9020102@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201003022329.58627.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 March 2010 23:25:48 William Bourque wrote:
> So if I get this right, this code is responsible of handling the b43
> devices, as well as several other PCI-E devices, correct?

Nah, this is a broadcom specific thing of the on-chip SSB bus.

> 
> Because now that you mention this, the wired network card (Marvel Yukon,
> with sky2 drivers) on this netbook also have a tons of issue (doesn't
> show in lspci on a clean boot, oops the kernel if network cable is
> unplugged while in use, fails to load if the module is ever unloaded, ... )
> I thought it was unrelated but from your comment, I feel like this could
> be linked to the same PCI-E bugs as well.

Uh, well. Are you sure your hardware is OK then?

-- 
Greetings, Michael.
