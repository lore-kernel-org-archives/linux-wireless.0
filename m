Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:46464 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751978AbXKQBf6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 20:35:58 -0500
Received: from morte (88-149-168-238.dynamic.ngi.it [88.149.168.238])
	(authenticated bits=0)
	by polimi.it (8.13.8/8.13.8) with ESMTP id lAH1ZsRp023291
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sat, 17 Nov 2007 02:35:56 +0100
Date: Sat, 17 Nov 2007 02:35:48 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: linux-wireless@vger.kernel.org
Subject: [BUG] libertas: probing for Marvell USB8388 fails
Message-ID: <20071117023548.79a7a33c@morte> (sfid-20071117_013600_584155_B9D1097E)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marvell USB8388, running on wireless-2.6. Firmware is:
421964206b0699014a11256ac48dd0a8  /lib/firmware/usb8388.bin

Loading the usb8xxx module, I get:
[203681.684283] usb8xxx: URB in failure status: -71
[203681.814072] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[203683.193744] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[203684.563428] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[203685.933099] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[203687.303025] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[203688.672443] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[203690.042118] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[203691.411789] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[203692.781455] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[203694.151134] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[203695.520804] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[203695.672729] usb8xxx: probe of 1-4:1.0 failed with error -12
[203695.672915] usbcore: registered new interface driver usb8xxx

Any clues?


-- 
Ciao
Stefano
