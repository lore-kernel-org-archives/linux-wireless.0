Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46808 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759715AbZJIKeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 06:34:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: Broadcom cards for free
Date: Fri, 9 Oct 2009 12:34:10 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200910091139.36089.mb@bu3sch.de> <69e28c910910090314j4e9885dfofbc58e901965b4ab@mail.gmail.com>
In-Reply-To: <69e28c910910090314j4e9885dfofbc58e901965b4ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910091234.12484.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 October 2009 12:14:24 Gábor Stefanik wrote:
> Sounds interesting... especially now that N-PHY is actually being
> reverse-engineered (or is it?).

I don't know if somebody is working on it, but the card could be useful for
somebody working on it.

> The modded 4320 is an attempt to replace the built-in OS and use it
> with b43 as a softmac device... am I right?

No, it was used to read the EEPROM. There were no attempts to reverse-engineer
and rewrite the EEPROM, however one can do that with this device.
It contains about 300kb data, so it's probably hard to reverse engineer.
However, I think there's no need to start over from zero, because most parts
of the device should be known. They're most likely just running their portable
driver kit on it.

-- 
Greetings, Michael.
