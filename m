Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50468 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbbFKIAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 04:00:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Z2xP9-0003ZU-8x
	for linux-wireless@vger.kernel.org; Thu, 11 Jun 2015 10:00:03 +0200
Received: from c-4dabdb54.030-194-6d6c6d4.cust.bredbandsbolaget.se ([84.219.171.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 10:00:03 +0200
Received: from quite by c-4dabdb54.030-194-6d6c6d4.cust.bredbandsbolaget.se with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 10:00:03 +0200
To: linux-wireless@vger.kernel.org
From: Daniel Lublin <quite@hack.org>
Subject: values in /proc/net/wireless are static, doesn't change; iwlwifi, Intel 6205
Date: Thu, 11 Jun 2015 07:55:23 +0000 (UTC)
Message-ID: <loom.20150611T094911-428@post.gmane.org> (sfid-20150611_100009_243262_EFBCBBEB)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm on a thinkpad X230 with Intel Advanced-N 6205 card, iwlwifi driver. 

Reading /proc/net/wireless, I find that the values there does not change. No 
matter me moving around, changing distance to my AP. On my old machine (X60), 
I was used to sometimes using for example wavemon(1) to find out where I get 
the best reception. I this a limitation of my network card, driver, or some 
combitation? As designed, or a flaw?

The values in question: Quality link/level/noise: 52.  -58.  -256


