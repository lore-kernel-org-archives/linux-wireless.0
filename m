Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59837 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757176AbZJ3UKF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 16:10:05 -0400
From: Malte Gell <malte.gell@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: Re: (SOLVED) ar9170usb from compat-wireless-2009-10-28
Date: Fri, 30 Oct 2009 21:10:08 +0100
References: <200910302100.08566.malte.gell@gmx.de>
In-Reply-To: <200910302100.08566.malte.gell@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200910302110.08465.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Malte Gell <malte.gell@gmx.de> wrote

> Hello!
> 
> I use a Fritz! WLAN N stick and the ar9170usb driver, but with
>  compat-wireless from 2009-10-28 I get no USB connection LED burning...

Forget it! It was a wpa_supplicant issue. Some weird setup, rebooting and now 
everything is fine. Wpa_supplicant tried to started twice, bad setup on my 
machine.
