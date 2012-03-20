Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14026 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758972Ab2CTP0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 11:26:41 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20328.41352.19571.126785@gargle.gargle.HOWL> (sfid-20120320_162646_311699_FE93310E)
Date: Tue, 20 Mar 2012 20:56:00 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: mac80211 20/40 coexist
In-Reply-To: <1332243154.3329.4.camel@jlt3.sipsolutions.net>
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
	<20328.2559.331884.450794@gargle.gargle.HOWL>
	<1332243154.3329.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> So what should we do with ath9k_htc? As I understood you, it relies on
> the no-longer updated global channel type?
> 
> IOW -- I don't think the patches we were discussing break it, Paul's
> patch would already have broken it. However my patch with the new
> callback could help you fix it?

I'll test ath9k_htc, see if it's broken and then wander off toward a red
horizon, er.. I mean, fix it or something. :)

Sujith
