Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout4.wanadoo.co.uk ([80.12.242.68]:49592 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3CZRPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 13:15:13 -0400
Date: Tue, 26 Mar 2013 18:15:10 +0100 (CET)
From: nick@nhthomas.freeserve.co.uk
Reply-To: nick@nhthomas.freeserve.co.uk
To: linux-wireless@vger.kernel.org
Message-ID: <9660788.35941364318110175.JavaMail.www@wwinf3701> (sfid-20130326_181516_966853_174F49A6)
Subject: Missing firmware file, fw_ext.ram.bin .
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

When I insert my ath6kl_usb based wifi device, I see that /var/log/messages says that it can't load two firmware files:

softmac.bin
and
fw_ext.ram.bin

Neither of these files are found in the source package.

I am guessing that the softmac.bin is just a method of using a different MAC address during development - and is probably optional.

But, what about the fw_ext.ram.bin file.

Is that necessary?


Regards

Nick Thomas
