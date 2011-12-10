Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:52271 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1LJWhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 17:37:25 -0500
Message-ID: <4EE3DF19.6080106@rolandgruber.de> (sfid-20111210_233736_101800_DCB59740)
Date: Sat, 10 Dec 2011 23:37:13 +0100
From: Roland Gruber <post@rolandgruber.de>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
CC: 651622@bugs.debian.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#651622: linux-2.6: Sitecom WLA-2000 v1.001 WLAN stick not
 supported
References: <20111210162607.1020.50335.reportbug@roland>		 <1323537258.18450.100.camel@deadeye> <4EE39C40.4030802@rolandgruber.de>	 <1323543622.25752.4.camel@deadeye> <4EE3D447.7030108@rolandgruber.de> <1323554710.25752.18.camel@deadeye>
In-Reply-To: <1323554710.25752.18.camel@deadeye>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I have some problem to get a Sitecom USB WLAN stick to run.
Ben tried to help me but we did not get it to work. So he pointed me to you. :)

It is the Sitecom WLA-2000 v1.001.

Vendor 0df6
Product 005d
Chipset Realtek RTL8191S

Dec 10 18:45:10 roland kernel: [18513.016012] usb 2-3: new high speed USB device number 9 using ehci_hcd
Dec 10 18:45:10 roland kernel: [18513.151122] usb 2-3: New USB device found, idVendor=0df6, idProduct=005d
Dec 10 18:45:10 roland kernel: [18513.151126] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Dec 10 18:45:10 roland kernel: [18513.151129] usb 2-3: Product: RTL8191S WLAN Adapter
Dec 10 18:45:10 roland kernel: [18513.151130] usb 2-3: Manufacturer: Manufacturer Realtek
Dec 10 18:45:10 roland kernel: [18513.151132] usb 2-3: SerialNumber: 00e04c000001

We tried to use the kernel module rtl8192cu by adding the IDs with "echo 0df6 005d > /sys/bus/usb/drivers/rtl8192cu/new_id".
But this led to a kernel oops.

Is there any way to setup the rtl8192cu kernel module so that it accepts the WLAN stick?
We also tried the module r8192u_usb but it complains about firmware loading problems when connecting the stick.


Thanks in advance for your help. Please let me know if you need more information.


- -- 

Best regards

Roland
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7j3xkACgkQq/ywNCsrGZ7FBgCfWe5STfX4fKYqc5oExB0CBmPy
36MAn3oCKMv+8D9e8PMkgnQ1BDlhX0g1
=6qSS
-----END PGP SIGNATURE-----
