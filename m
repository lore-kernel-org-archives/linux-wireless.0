Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep11-int.chello.at ([62.179.121.31]:53090 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbZGSNmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 09:42:07 -0400
Received: from edge05.upc.biz ([192.168.13.212]) by viefep11-int.chello.at
          (InterMail vM.7.09.01.00 201-2219-108-20080618) with ESMTP
          id <20090719134201.LUEI27079.viefep11-int.chello.at@edge05.upc.biz>
          for <linux-wireless@vger.kernel.org>;
          Sun, 19 Jul 2009 15:42:01 +0200
Message-ID: <ABEC48F218774102B9939CE6F5F5F856@Emiel>
From: "Emiel Bruijntjes" <emiel@bruijntjes.net>
To: <linux-wireless@vger.kernel.org>
Subject: Enabling and disabling Atheros AR9258 wireless card
Date: Sun, 19 Jul 2009 15:41:38 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I hope this is the right channel to report a bug/feature-request.

My laptop (Toshiba NB200) uses a Atheros AR9285 wireless card. Wireless is 
currently disabled, and the wireless LED is off. This is the default factory 
setting. There is no way to enable the wireless module from Linux. On 
Windows, the Fn/F8 key combination enables and disables the wireless module, 
and turns on or off the LED. On Linux however, this isn't working.

The advice that I read on discussion forums on the web was to boot Windows, 
turn on wireless, and then boot Linux again (see http://tjmcgrew.com/). It 
is - as far as I know - not possible to use the Atheros AR9285 wireless card 
on a Linux computer, without running Windows first to enable it. This is not 
very good.

To sum up:
- From Linux it is not possible to enable/disable the Atheros AR9285 
wireless card, and to turn on and off the wireless LED.
- This should be fixed as the wireless card is disabled by default, and it 
is thus impossible to use it on a system without installing and running 
Windows first.

Emiel Bruijntjes 

