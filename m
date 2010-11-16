Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.ralinktech.com.tw ([211.75.121.152]:49179 "HELO
	smtp.ralinktech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759175Ab0KPCRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 21:17:32 -0500
From: RA-Jay Hung <Jay_Hung@ralinktech.com>
To: Walter Goldens <goldenstranger@yahoo.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: RE: [PATCH 7/9] rt2x00: Fix rt2800 USB TX Path DMA issue
Date: Tue, 16 Nov 2010 01:59:06 +0000
Message-ID: <B7288B2B5878D747BA031EF4B170D7F6BC347E@TWHCMBS01.tw.ralinktech.ad>
References: <201011131911.47346.IvDoorn@gmail.com>
 <310488.65157.qm@web56802.mail.re3.yahoo.com>
In-Reply-To: <310488.65157.qm@web56802.mail.re3.yahoo.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> These patches appear to have finally brought some life in to the rt307x chips in
> terms of stability and usability. There are no more duplicate (very few) or lost
> packets and overall, the driver is improved immensely, however the latency is
> increased compared to the STA driver. Pinging my gateway with STA yields about
> 2-3ms average, whereas the rt2800usb is about 8-9ms. The throughput is also
> about 20% less. Do you think this can be corrected at some point and do you
> anticipate further improvements in this direction?

Yes, we will continue improve functionally and throughput of Ralink chips, thanks.

jay
CONFIDENTIALITY STATEMENT : The information, attachments and any rights attaching in this e-mail are confidential and privileged; it is intended only for the individual or entity named as the recipient hereof.Any disclosure, copying, distribution, dissemination or use of the contents of this e-mail by persons other than the intended recipient is STRICTLY PROHIBITED and may violate applicable laws.If you have received this e-mail in error, please delete the original message and notify us by return email or collect call immediately. Thank you.
