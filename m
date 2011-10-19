Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wipro-blr-out01.wipro.com ([203.91.198.74]:38610 "EHLO
	wipro-blr-out01.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1JSM4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 08:56:03 -0400
From: <raghunathan.kailasanathan@wipro.com>
To: <linux-wireless@vger.kernel.org>
Subject: Ralink RT3070: absolute transmit power information
Date: Wed, 19 Oct 2011 12:40:52 +0000
Message-ID: <F099D0EF3989304DBA09D2E81781FF0B049E41F9@BLR-SJP-MBX4.wipro.com> (sfid-20111019_145608_922430_489E7B91)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
On my ubuntu machine I can view transmit power used by RT3070 driver using "iwpriv ra0 show TxPower". 
It looks like this returns results in percentage - I got 75 (implying 75%). 

How do I get the absolute transmit power used (in dBm or mW) ?

Regards
Raghu
