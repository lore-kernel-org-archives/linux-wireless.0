Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway.eealab.unian.it ([193.205.128.50]:44621 "EHLO
	routerc.dibet.univpm.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750946AbZIYJWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 05:22:45 -0400
Received: from thor.deit.univpm.it ([193.205.130.201] ident=michele)
	by routerc.dibet.univpm.it with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <m.alessandrini@deit.univpm.it>)
	id 1Mr6Sx-0002T9-Tw
	for linux-wireless@vger.kernel.org; Fri, 25 Sep 2009 10:47:47 +0200
From: Michele Alessandrini <m.alessandrini@deit.univpm.it>
To: linux-wireless@vger.kernel.org
Subject: zd1211rw on Debian not working with new kernels
Date: Fri, 25 Sep 2009 10:47:46 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909251047.46826.m.alessandrini@deit.univpm.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everybody,
I have a Sitecom WL-113 USB wireless adapter, and I use Debian testing with 
zd1211rw. My wireless network uses WPA.
The adapter is working with kernel up to 2.6.24. It is not working anymore 
with kernels 2.6.26 and 2.6.30 (these are the kernels I could test).
>From what I can see, wpa_supplicant gets a series of errors from the driver 
when it tries to associate to the network.
Provided that the OS is exactly the same, and the only variable is which 
kernel is booted, I think it's something related to the driver (kernel 2.6.26 
is where the MAC layer has been changed) or to the interface between it and 
wpa_supplicant.
I'm just writing to ask if this is a know issue or if someone else is getting 
similar problems.
Thank you very much for your work
Bye
Michele Alessandrini, Italy
