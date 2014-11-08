Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from st11p02mm-asmtpout002.mac.com ([17.172.220.237]:48408 "EHLO
	st11p02mm-asmtp002.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918AbaKHRdf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2014 12:33:35 -0500
Received: from [192.168.1.251] (i5E86CD40.versanet.de [94.134.205.64])
 by st11p02mm-asmtp002.mac.com
 (Oracle Communications Messaging Server 7u4-27.10(7.0.4.27.9) 64bit (built Jun
  6 2014)) with ESMTPSA id <0NEQ00FVFB9SYJA0@st11p02mm-asmtp002.mac.com> for
 linux-wireless@vger.kernel.org; Sat, 08 Nov 2014 16:33:12 +0000 (GMT)
From: efill@me.com
Content-type: text/plain; charset=windows-1252
Subject: Intel Wireless 7260 + 5G + AP mode
Message-id: <733AE580-92D4-486C-888C-9694F6AAB92F@me.com> (sfid-20141108_183343_565029_2BB612E0)
Date: Sat, 08 Nov 2014 17:33:10 +0100
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
MIME-version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I’m trying to get the 7260 to act as an AP on the 5G band. Unfortunately it seems to be impossible due to the „no IR“ reg domain restriction done by the Intel firmware internally (this is what I’ve googled so far..).

Could someone explain to me the technical background of this. As far as I understood the regulation if DFS and TPC are used, most of the 5G channels are allowed. Did I miss something? What’s the point of restricting the IR then?

And finally: Is there a way to get it work? Some other PCI-E chip? ath10k?

All the best,
Efill