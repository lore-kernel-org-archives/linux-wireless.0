Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout9.freenet.de ([195.4.92.99]:52555 "EHLO mout9.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab1EORj5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 13:39:57 -0400
Received: from [195.4.92.15] (helo=5.mx.freenet.de)
	by mout9.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QLfIJ-0000FX-I8
	for linux-wireless@vger.kernel.org; Sun, 15 May 2011 19:39:55 +0200
Received: from p54a187d2.dip0.t-ipconnect.de ([84.161.135.210]:52534 helo=mail.maya.org)
	by 5.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QLfIJ-0005aU-7x
	for linux-wireless@vger.kernel.org; Sun, 15 May 2011 19:39:55 +0200
Message-ID: <4DD00FD1.90703@01019freenet.de> (sfid-20110515_194001_300096_FF91AF3A)
Date: Sun, 15 May 2011 19:39:29 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: users@rt2x00.serialmonkey.com
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: rt2800pci: possible reason for: rt2800pci_txdone: Warning - Got TX
 status for an empty queue 0, dropping - compiler?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

today, I had to switch to openSuSE 11.3 because of end of life of 
openSuSE 11.2.

I thought, that this would be a small thing, because I used the same 
kernel in 11.2 as in 11.3 (both times 2.6.34.9-7-desktop): openSUsE had 
for 11.2 the same kernel additionally. The only difference between them: 
the kernel for openSuSE 11.2 was compiled with gcc 4.4.1 (gcc 4.4 branch 
revision 150839) - the kernel for openSuSE 11.3 is compiled with gcc 
4.5.0 (gcc 4.5 branch revision 160292).

With the gcc 4.4.1-compiled kernel, the "rt2800pci_txdone: Warning - Got 
TX status for an empty queue 0, dropping" came up rarely (but it came 
up, too), with the gcc 4.5.0 compiled kernel, this warning comes up 
after a few seconds of sending data with netperf (throughput is > 10 
MB's) and 45 times(!). The connection is dead after that storm!

If you do not have this problem - which gcc do you use or which options 
do you use for compiling?


Kind regards,
Andreas

