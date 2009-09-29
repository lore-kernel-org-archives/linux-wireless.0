Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50910 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750698AbZI2LHC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 07:07:02 -0400
From: Malte Gell <malte.gell@gmx.de>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: compat-wireless tracepoint error Re: [Ndiswrapper-general] Need help to create driver for Netgear WN111v2
Date: Tue, 29 Sep 2009 13:07:03 +0200
Cc: linux-wireless@vger.kernel.org
References: <999306.93095.qm@web23102.mail.ird.yahoo.com> <200909291145.35972.malte.gell@gmx.de> <3ace41890909290328l14620ed6o4939488e268d76a3@mail.gmail.com>
In-Reply-To: <3ace41890909290328l14620ed6o4939488e268d76a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200909291307.03227.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


"Hin-Tak Leung" <hintak.leung@gmail.com> wrote

> CONFIG_COMPAT_WIRELESS_28
> 

Jep, changed to 27, but, did not compile......:

/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-29/drivers/net/wireless/ath/ar9170/usb.c: In function 
‘ar9170_usb_cancel_urbs’:
/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-29/drivers/net/wireless/ath/ar9170/usb.c:380: error: implicit 
declaration of function ‘usb_poison_anchored_urbs’
make[5]: *** [/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-29/drivers/net/wireless/ath/ar9170/usb.o] Fehler 1
make[4]: *** [/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-29/drivers/net/wireless/ath/ar9170] Fehler 2
make[3]: *** [/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-29/drivers/net/wireless/ath] Fehler 2
make[2]: *** [/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-29/drivers/net/wireless] Fehler 2
make[1]: *** [_module_/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-29] Fehler 2
make[1]: Leaving directory `/usr/src/linux-2.6.27.29-0.1'
make: *** [modules] Fehler 2

