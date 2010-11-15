Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56802.mail.re3.yahoo.com ([66.196.97.76]:47330 "HELO
	web56802.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754082Ab0KOJp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 04:45:26 -0500
Message-ID: <310488.65157.qm@web56802.mail.re3.yahoo.com>
Date: Mon, 15 Nov 2010 01:45:24 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH 7/9] rt2x00: Fix rt2800 USB TX Path DMA issue
To: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, jay_hung@ralinktech.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
In-Reply-To: <201011131911.47346.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

These patches appear to have finally brought some life in to the rt307x chips in terms of stability and usability. There are no more duplicate (very few) or lost packets and overall, the driver is improved immensely, however the latency is increased compared to the STA driver. Pinging my gateway with STA yields about 2-3ms average, whereas the rt2800usb is about 8-9ms. The throughput is also about 20% less. Do you think this can be corrected at some point and do you anticipate further improvements in this direction?

Walter


      
