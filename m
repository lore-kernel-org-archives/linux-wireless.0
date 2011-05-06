Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:59289 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932654Ab1EFUyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 16:54:47 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-66-79-239-161.nexicom.net [66.79.239.161])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p46Ksjtb032570
	for <linux-wireless@vger.kernel.org>; Fri, 6 May 2011 16:54:46 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 669BD1E0183
	for <linux-wireless@vger.kernel.org>; Fri,  6 May 2011 16:54:44 -0400 (EDT)
Message-ID: <4DC46034.7000901@lockie.ca> (sfid-20110506_225450_439822_F1683D91)
Date: Fri, 06 May 2011 16:55:16 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Failed to stop TX DMA in 100 msec after killing last frame, ath:
 Failed to stop TX DMA! cause my scans not to work right.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I almost had a breakthrough (but it is not repeatable).
I did:
modprobe ath9k debug=0xffffffff

and it WORKED. :-)

It didn't work when I rebooted.

I would suspect a hardware problem except it works 100% in kernel 2.6.4.
