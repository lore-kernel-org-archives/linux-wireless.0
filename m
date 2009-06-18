Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f175.google.com ([209.85.222.175]:37908 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757661AbZFRCcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 22:32:13 -0400
Received: by pzk5 with SMTP id 5so8529pzk.33
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 19:32:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090618021017.19879.qmail@stuge.se>
References: <ec2083b20906120654j370e5bdo724a7c3b6d505a6c@mail.gmail.com>
	 <4A326771.6030301@lwfinger.net>
	 <ec2083b20906120759x4a8c247eh61d1f6bdb6f194f6@mail.gmail.com>
	 <20090618021017.19879.qmail@stuge.se>
Date: Wed, 17 Jun 2009 21:32:15 -0500
Message-ID: <ec2083b20906171932g401fab8fk15531459e1dc4d41@mail.gmail.com>
Subject: Re: 4311 not detected at all
From: "Fabio A. Correa" <facorread@gmail.com>
To: "Fabio A. Correa" <facorread@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/17 Peter Stuge <peter@stuge.se>:
> You may be able to use flashrom as developed by the coreboot project
> to flash your BIOS. Maybe. If not, come on IRC or the mailing list
> and we can try to help you get it to work on your laptop.

Thank you very much. I emerged it on my Gentoo laptop and the BIOS was
detected, but:

Found chipset "Intel ICH7M", enabling flash write...
BIOS Lock Enable: disabled, BIOS Write Enable: disabled, BIOS_CNTL is
0x0

Root Complex Register Block address = 0xfed1c000
GCS = 0xc60: BIOS Interface Lock-Down: disabled, BOOT BIOS Straps: 0x3 (LPC)
Top Swap : not enabled

The BIOS could not be read into a file, so I will not try to write it.
Anyways, thanks for your help.

-- 
Fabio Andrés Correa Durán
