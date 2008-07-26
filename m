Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:46252
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838AbYGZQmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 12:42:18 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: linux-wireless@vger.kernel.org
Subject: ath9k working, almost
Date: Sat, 26 Jul 2008 17:42:15 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200807261742.15693.alistair@devzero.co.uk> (sfid-20080726_184221_373308_F14AAE17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The newly announced ath9k driver works great on an AR5418 Core 2 Duo Macbook, 
WPA2-TKIP/AES et al all work fine. It would be good to see this driver in 
wireless-testing, it completely replaces madwifi for me. I used linux.git 
(2.6.26) + wireless-testing.git + my-wireless-testing.git with success.

The only thing that I couldn't get working was the signal strength meter in 
knetworkmanager. The AP signal strength shows up in iwlist ath0 scanning, but 
whatever NM uses doesn't seem to work. All is good with madwifi, by 
comparison.

Any ideas? NM issue?

-- 
Cheers,
Alistair.
