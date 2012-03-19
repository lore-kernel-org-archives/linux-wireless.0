Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39811 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab2CSKFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 06:05:24 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20327.1220.845693.349959@gargle.gargle.HOWL> (sfid-20120319_110528_368319_6E5631F0)
Date: Mon, 19 Mar 2012 15:34:52 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: mac80211 20/40 coexist
In-Reply-To: <1332145412.3359.2.camel@jlt3.sipsolutions.net>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	<1331902885.6753.10.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
	<1332065984.3609.5.camel@jlt3.sipsolutions.net>
	<20326.41009.17936.152095@gargle.gargle.HOWL>
	<1332145412.3359.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Actually, no -- that's how we got into this mess to start with :-)
> Bandwidth here is a per-peer property, BSS_CHANGED_HT is changing the
> operation mode (things like non-HT protection).
> 
> We used to change the channel bandwidth when the AP wanted to only
> receive 20 MHz, but that seems like a bug because that doesn't even
> necessarily mean it wants to TX 20 MHz.

11.14.4.3 specifies that if the operating bandwidth has been changed by the AP
to 20 MHz, then transmitting frames in an extension channel is not allowed ?

Sujith
