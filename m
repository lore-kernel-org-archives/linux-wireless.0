Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 007.netroom.de ([194.0.247.207]:17333 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbZKDRlS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 12:41:18 -0500
Message-ID: <4AF1BCBD.7010605@draisberghof.de>
Date: Wed, 04 Nov 2009 18:41:17 +0100
From: Josua Dietze <digidietze@draisberghof.de>
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
	Frank Schaefer <schaefer.frank@gmx.net>,
	USB list <linux-usb@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB
 N devices in cdrom mode
References: <Pine.LNX.4.44L0.0911041036100.2968-100000@iolanthe.rowland.org> <200911041741.32128.oliver@neukum.org>
In-Reply-To: <200911041741.32128.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oliver Neukum schrieb:

> I am afraid this will spread beyond modems. For now I'd like
> those devices which are affected by resets to get a quirk that
> marks them as not resettable for purposes of error handling. But
> I fear we may have to face this system in the future on a regular
> basis.


I had similar thoughts when I first encountered a device with 
drivers "on board". But so far (around three years now) only 
wireless communication devices have shown up.

My guess is that these things are basically working with cell phone 
chipsets most of which have the "dual device" built in; many 
cellphones can USB-connect as "modem" or "storage".

So it's just a case of using what's there already and would probably 
lie around unnoticed otherwise.


Josua Dietze
-- 
Man is the only creature on earth enabled to take a
warm meal while flying!                      Loriot
