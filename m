Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mrs.ro ([109.74.194.28]:58596 "EHLO mrs.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbZLTNiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 08:38:19 -0500
Received: from localhost (localhost [127.0.0.1])
	by mrs.ro (Postfix) with ESMTP id 4F0FA7BF9
	for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2009 15:10:57 +0200 (EET)
Received: from mrs.ro ([127.0.0.1])
	by localhost (mail.mrs.ro [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mwI1Bn1RVGHu for <linux-wireless@vger.kernel.org>;
	Sun, 20 Dec 2009 15:10:56 +0200 (EET)
Received: from nero.localnet (a88-112-30-248.elisa-laajakaista.fi [88.112.30.248])
	by mrs.ro (Postfix) with ESMTP id 64B367BED
	for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2009 15:10:55 +0200 (EET)
From: Valentin Manea <linux-wireless@mrs.ro>
To: linux-wireless@vger.kernel.org
Subject: Intel 4965 HT rates
Date: Sun, 20 Dec 2009 15:10:51 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200912201510.51812.linux-wireless@mrs.ro>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

  I'm running compat-wireless-2.6.33-rc1 and iw list shows some confusing HT 
capabilities:
        Band 1:            
                HT capabilities: 0x082c
                        * 20 MHz operation
                        * SM PS disabled  
                        * 20 MHz short GI 
                        * max A-MSDU len 7935

but for 802.11a channels:
        Band 2:                                                               
                HT capabilities: 0x086e                                       
                        * 20/40 MHz operation                                 
                        * SM PS disabled                                      
                        * 20 MHz short GI                                     
                        * 40 MHz short GI                                     
                        * max A-MSDU len 7935

While I can't tell when this happened, I remember older 2.6.29 releases 
supported HT40 for both bands.
The wireless card is an Intel 4965 on a Thinkpad T61.


Regards,
Valentin

