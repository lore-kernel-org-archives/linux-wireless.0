Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58357 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751448AbYIEUyh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 16:54:37 -0400
Message-ID: <48C19C8B.4020301@gmx.de> (sfid-20080905_225441_171537_2309AD3E)
Date: Fri, 05 Sep 2008 22:54:35 +0200
From: Friedrich Beckmann <friedrich.beckmann@gmx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: RE: minimum payload size for FEC
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 > So here is my question:
 >
 > Is there any situation where the payload to the Viterbi FEC is less
 > than
 > 256 bits (= 32 bytes) ? (ie. a beacon and such stuff?)
 >

I guess the ACK packet is shorter than that (14 Bytes), if I remember 
correctly. You can have a look in the standard IEEE 802.11.

Regards

Friedrich

