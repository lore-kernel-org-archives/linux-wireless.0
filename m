Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hyde.gogi.tv ([87.106.167.24]:43479 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759080Ab0HEQUK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 12:20:10 -0400
From: Daniel Haid <d.haid@gogi.tv>
To: "ABM Musa" <amusa2@uic.edu>
Subject: Re: Capturing packets with bad FCS in monitor mode
Date: Thu, 5 Aug 2010 18:19:55 +0200
Cc: linux-wireless@vger.kernel.org
References: <201008051614.11546.d.haid@gogi.tv> <475A8455ABBB4AD79E2B0AD03B1F69B9@personal>
In-Reply-To: <475A8455ABBB4AD79E2B0AD03B1F69B9@personal>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008051819.55252.d.haid@gogi.tv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Packets with crc error can be captured using corresponding flag of iw.
> 
> iw phy phy0 interface add wlan0 type monitor flags fcsfail

Is this supported on ath9k? I do not see any difference so far
with the packet capturing.
I also do not find the FIF_FCSFAIL flag be used anywhere in
the ath9k code.

Will I get lots of corrupted packets if this is enabled properly or only
casually?
