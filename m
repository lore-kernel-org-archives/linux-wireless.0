Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:46221 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787AbYAKU75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 15:59:57 -0500
Received: from ssnt2.quns.cam.ac.uk ([131.111.255.37]:49910 helo=neotoaster.lan)
	by ppsw-0.csi.cam.ac.uk (smtp.hermes.cam.ac.uk [131.111.8.150]:25)
	with esmtpsa (PLAIN:ssnt2) (TLSv1:DHE-RSA-AES256-SHA:256)
	id 1JDQyk-0001Rb-00 (Exim 4.67) for linux-wireless@vger.kernel.org
	(return-path <ssnt2@hermes.cam.ac.uk>); Fri, 11 Jan 2008 20:59:50 +0000
From: Shawn Tan <ssnt2@eng.cam.ac.uk>
Reply-To: ssnt2@eng.cam.ac.uk
To: linux-wireless@vger.kernel.org
Subject: B43 problems
Date: Fri, 11 Jan 2008 20:59:45 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801112059.45467.ssnt2@eng.cam.ac.uk> (sfid-20080111_210003_687423_0585CA34)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've just successfully downloaded compat-wireless, compiled and loaded the 
latest B43 module. I can do iwlist scan and get an IP from my router. I can 
ping my router. However, the connection only lasts for a few seconds. Then, I 
need to re-associate again.

dmesg regularlly shows this message:
[882193.464000] b43-phy0 ERROR: PHY transmission error
[882207.008000] b43-phy0 ERROR: PHY transmission error
[882207.008000] b43-phy0 ERROR: PHY transmission error

and, a few times, I get disassociated with the router:
[881898.392000] b43-phy0 ERROR: PHY transmission error
[881923.416000] wlan0: deauthenticate(reason=3)
[881924.508000] rx BA session requested to stop on inactive tid 0

cheers.

-- 
with metta,
Shawn Tan

Centre for Advanced Photonics and Electronics
Department of Engineering, University of Cambridge
9 JJ Thomson Avenue, Cambridge CB3 0FA, UK.
