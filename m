Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48476 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2CTEkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 00:40:18 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20328.2559.331884.450794@gargle.gargle.HOWL> (sfid-20120320_054023_748410_CB38594E)
Date: Tue, 20 Mar 2012 10:09:27 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: mac80211 20/40 coexist
In-Reply-To: <1332159511.3359.24.camel@jlt3.sipsolutions.net>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	<1331902885.6753.10.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
	<1332065984.3609.5.camel@jlt3.sipsolutions.net>
	<20326.41009.17936.152095@gargle.gargle.HOWL>
	<1332145412.3359.2.camel@jlt3.sipsolutions.net>
	<20327.1220.845693.349959@gargle.gargle.HOWL>
	<1332151743.3359.19.camel@jlt3.sipsolutions.net>
	<20327.2859.202760.119343@gargle.gargle.HOWL>
	<1332155566.3359.22.camel@jlt3.sipsolutions.net>
	<1332159511.3359.24.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Technically, but that would be assuming it's implemented everywhere ...
> if it was tested by the WFA we'd implement it :-)

Heh :)

> Also, in order to actually implement it in AP mode we need to use the
> "RC update only".
> 
> I think it makes more sense to unify the handling here -- change rate
> control (and also tell the driver, like one of my patches did) rather
> than treating 20/40 changes in managed mode differently than in AP mode.

Agreed.

Sujith
