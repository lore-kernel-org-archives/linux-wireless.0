Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.bemta8.messagelabs.com ([216.82.243.196]:34720 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757363Ab3GEPaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 11:30:03 -0400
Message-ID: <51D6E484.9060000@digi.com> (sfid-20130705_173007_698109_9AB64DDE)
Date: Fri, 5 Jul 2013 17:21:40 +0200
From: Hector Palacios <hector.palacios@digi.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: <kvalo@qca.qualcomm.com>, <ath6kl-devel@qualcomm.com>
Subject: Passing a custom MAC to ath6kl
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings,

Is there a way to pass a custom MAC address to the ath6kl upstream driver?
In the ISC version of the driver, a softmac.c file is provided that reads a MAC from a 
file if a module parameter softmac_enable=1 is passed.
Is there any reason why this has not made it upstream?

Best regards,
--
Hector Palacios
