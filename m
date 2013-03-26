Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout1.wanadoo.co.uk ([80.12.242.29]:44683 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3CZVYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 17:24:24 -0400
Date: Tue, 26 Mar 2013 22:24:22 +0100 (CET)
From: nick@nhthomas.freeserve.co.uk
Reply-To: nick@nhthomas.freeserve.co.uk
To: linux-wireless@vger.kernel.org
Message-ID: <8059861.133751364333062523.JavaMail.www@wwinf3721> (sfid-20130326_222429_260076_76391FC0)
In-Reply-To: <9660788.35941364318110175.JavaMail.www@wwinf3701>
Subject: RE: Missing firmware file, fw_ext.ram.bin .
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I found another firmware file in the package - called fw_ext.ram_64k.bin .

But, why does the code refer to a file called fw_ext.ram.bin ?!?!?


Regards

Nick


> Message Received: Mar 26 2013, 05:15 PM
> From: nick@nhthomas.freeserve.co.uk
> To: linux-wireless@vger.kernel.org
> Cc: 
> Subject: Missing firmware file, fw_ext.ram.bin .
> 
> Hi,
> 
> When I insert my ath6kl_usb based wifi device, I see that /var/log/messages says that it can't load two firmware files:
> 
> softmac.bin
> and
> fw_ext.ram.bin
> 
> Neither of these files are found in the source package.
> 
> I am guessing that the softmac.bin is just a method of using a different MAC address during development - and is probably optional.
> 
> But, what about the fw_ext.ram.bin file.
> 
> Is that necessary?
> 
> 
> Regards
> 
> Nick Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> 

