Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from buzzloop.caiaq.de ([212.112.241.133]:44555 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932928AbZHGTMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 15:12:03 -0400
Date: Fri, 7 Aug 2009 21:11:56 +0200
From: Daniel Mack <daniel@caiaq.de>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Libertas: Association request to the driver failed
Message-ID: <20090807191156.GS19257@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since a recent merge of the wireless tree to Linus' master, my SDIO
connected libertas module fails to connect to our WLAN.

'iwlist scanning' works fine, but wpa_supplicant keeps on spitting out
the following message:

  CTRL-EVENT-SCAN-RESULTS 
  Trying to associate with 00:04:0e:4b:c7:b3 (SSID='caiaq' freq=2437 MHz)
  Association request to the driver failed

Haven't done any bisect or deeper inspection of recent changes yet. Can
anyone point me in some direction maybe? The change must have been
introduced between -rc3 and -rc5. My userspace did not change since
then.

Thanks,
Daniel

