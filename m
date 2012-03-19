Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26316 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab2CSKcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 06:32:42 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20327.2859.202760.119343@gargle.gargle.HOWL> (sfid-20120319_113247_428938_F1326596)
Date: Mon, 19 Mar 2012 16:02:11 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: mac80211 20/40 coexist
In-Reply-To: <1332151743.3359.19.camel@jlt3.sipsolutions.net>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	<1331902885.6753.10.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
	<1332065984.3609.5.camel@jlt3.sipsolutions.net>
	<20326.41009.17936.152095@gargle.gargle.HOWL>
	<1332145412.3359.2.camel@jlt3.sipsolutions.net>
	<20327.1220.845693.349959@gargle.gargle.HOWL>
	<1332151743.3359.19.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> > 11.14.4.3 specifies that if the operating bandwidth has been changed by the AP
> > to 20 MHz, then transmitting frames in an extension channel is not allowed ?
> 
> Ok, good point. Paul's case was regulatory related, where we
> (voluntarily) ceased 40 MHz transmissions.
> 
> Still though, I think reconfiguring the channel type rather than the
> rate control algorithm doesn't make a lot of sense in this case since
> it'd make this very special and unlike the other cases (e.g. AP mode).

The regulatory issue could have been fixed by sending out the action frame
specified in 7.4.10.2, no ?

Sujith
