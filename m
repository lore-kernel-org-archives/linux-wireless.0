Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:19487 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbZG2Luq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 07:50:46 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Mladen Horvat <acid-burn@opendreambox.org>
Subject: Re: zd1211rw couldn't load firmware. Error number -145 with Kernel 2.6.30
Date: Wed, 29 Jul 2009 13:50:27 +0200
Cc: linux-wireless@vger.kernel.org
References: <loom.20090729T111851-320@post.gmane.org>
In-Reply-To: <loom.20090729T111851-320@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907291350.27426.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> [  415.271000] usb 1-1: upload_firmware() 
> firmware device id 0x4810 is equal to the actual device id

Looks like your firmware could be successfully loaded and checked 
by the driver.


> [  416.350000] usb 1-1: USB control request for firmware
> upload failed. Error number -145

Looks like an URB (USB request block) couldn't transferred to the 
device. As you speak about an embedded device: are you sure that 
your USB hardware works correctly?

-- 
http://www.holgerschurig.de
