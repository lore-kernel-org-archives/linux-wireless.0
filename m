Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54682 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab2CSC4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2012 22:56:39 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20326.41009.17936.152095@gargle.gargle.HOWL> (sfid-20120319_035642_900753_4EC5AE01)
Date: Mon, 19 Mar 2012 08:25:45 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: mac80211 20/40 coexist
In-Reply-To: <1332065984.3609.5.camel@jlt3.sipsolutions.net>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	<1331902885.6753.10.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
	<1332065984.3609.5.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> I'm not sure I can believe this -- surely the firmware has to have a way
> of dealing with stations that can't do 40 MHz and stations that can, so
> switching between the two doesn't seem like a major proposal? We also
> don't currently handle the action frames for that, but it seems like we
> should.

We have BSS_CHANGED_HT for doing this.

Sujith
