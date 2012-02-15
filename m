Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52066 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab2BOKAI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:00:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Rxbee-000468-7J
	for linux-wireless@vger.kernel.org; Wed, 15 Feb 2012 11:00:07 +0100
Received: from sw.montavista.co.jp ([202.232.97.131])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 11:00:04 +0100
Received: from sshukla82 by sw.montavista.co.jp with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 11:00:04 +0100
To: linux-wireless@vger.kernel.org
From: Santosh Shukla <sshukla82@hotmail.com>
Subject: Re: wl1271: how to use without runtime pm
Date: Wed, 15 Feb 2012 09:57:39 +0000 (UTC)
Message-ID: <loom.20120215T101548-412@post.gmane.org> (sfid-20120215_110014_213295_3240DB1D)
References: <20101230000737.74d30852@lair>  <AANLkTim55FJ_cBE1M7HmhVagfphntZZBLSs9NjTmK_F+@mail.gmail.com>  <20101231010847.79a55fda@lair> <1293782416.15791.10.camel@powerslave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there any resolution for this mail thread? I too came across this problem. My 
H/W has WLAN_EN bit high( a h/w Switch) and Physically can not be configured for 
RUN-TIME feature. So, I will have to run wl128x compat module without RUN-TIME 
support. 

Could any one suggest workaround for same so that I don't see SDIO WR/RD error
for sequence of wireless node down , followed by up (referred in this mail 
thread).

Appreciate your opinion.

