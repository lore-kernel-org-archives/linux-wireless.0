Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from uhura.skim.hs-owl.de ([193.174.118.81]:38153 "EHLO
	uhura.skim.hs-owl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0JGKAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 06:00:43 -0400
Received: from raven04.svc.hs-owl.de ([193.174.118.179]:61249 helo=exchange.hs-owl.de)
	 by uhura2.skim.hs-owl.de with esmtps
	(Cipher TLS1.0:RSA_AES_128_CBC_SHA1:16)   (Exim 4.69 #1 (EximConfig 2.5))
	 id 1P3mtw-0001xX-Qv   
	for <linux-wireless@vger.kernel.org>; Thu, 07 Oct 2010 11:36:36 +0200
Message-ID: <4CAD9368.70608@gmx.com>
Date: Thu, 7 Oct 2010 11:31:20 +0200
From: Bjoern Czybik <wlfw@gmx.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
Subject: Vendor specific data within a beacon frame
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am a student from Germany and a newbie to Linux device driver 
programming and the wireless drivers.
We are using the ath5k device driver and hostapd.

In our project we are looking to send some specific data within each 
beacon (should be set from the hostapd).
In which struct can I set the vendor specific data in a beacon frame?

Björn
