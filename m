Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37795 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbbCRVPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 17:15:53 -0400
Received: by igcqo1 with SMTP id qo1so56994429igc.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2015 14:15:53 -0700 (PDT)
Received: from [100.64.173.2] (public-254-46.nat.utoronto.ca. [138.51.254.46])
        by mx.google.com with ESMTPSA id t1sm2516309igs.0.2015.03.18.14.15.52
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Wed, 18 Mar 2015 14:15:52 -0700 (PDT)
Date: Wed, 18 Mar 2015 17:15:51 -0400
Subject: fast wireless restart on raspberry pi
From: Orozco <felipe.orozco32@gmail.com>
To: <linux-wireless@vger.kernel.org>
Message-ID: <5162B74B-89E1-4A6D-AB76-8C5D55D15A99@gmail.com> (sfid-20150318_221557_115743_1D997173)
Mime-version: 1.0
Content-type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am working on a project where I need to be able to modify a wireless 
adapter's firmware. I'm trying to use the TP-LINK TL-WN821N with the 
8192cu driver and firmware on a Raspberry Pi 2. I am trying to be able to 
quickly stop the transmission of packets then and just as quickly be able 
to restart the transmission. Ideally, I would be able to do a single 
stop/start in less time than it takes to transmit a packet.

I would be very thankful if someone could tell me where would be a good 
place to start, and share any knowledge they have.

-Felipe	

						
					


				
			
		
					
				
			
		






