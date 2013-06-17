Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54525 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab3FQDSe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jun 2013 23:18:34 -0400
Received: from mailout-de.gmx.net ([10.1.76.34]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MbeUV-1V5GYe03sb-00J3Y4 for
 <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 05:18:33 +0200
Message-ID: <51BE8008.20302@gmx.de> (sfid-20130617_051837_154291_7B24238B)
Date: Mon, 17 Jun 2013 05:18:32 +0200
From: Lars Zastrow <Lars.Zastrow@gmx.de>
MIME-Version: 1.0
To: backports@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: bug-report: Ralink corp. Device [1814:539a] - Kernel 3.8 +
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Team,

I'am using the following wireless-network-device:

Network controller [0280]: Ralink corp. Device [1814:539a]
Subsystem: Hewlett-Packard Company Device [103c:1839]
Kernel driver in use: rt2800pci

I had problems with it since I bought my laptop... The driver was 
unstable with the kernel I used back in autumn 2012. Howeverer, one 
kernel-update fixed it. Must be something about 3.4x?

It was defenetly working with the Kernels from 3.5 till 3.7 on multible 
distros. 3.8 was bringing back the old Problems:

- extremly low signal
- hard to establish a connection to any acess-point.

The last "problematic" kernel I have testet was 3.9.5-1 on Arch-Linux. 
Compiling the compat-drivers manually did not bring any fix.

I am currently using 3.7.4-1 wich is working.

Best regards

Lars Zastrow
