Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36041 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbbAGNDz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 08:03:55 -0500
Message-ID: <1420635832.3407.7.camel@sipsolutions.net> (sfid-20150107_140358_532033_F1D23EB4)
Subject: Re: [PATCH v3] cfg80211: check for carrier state only when
 offchanel CAC supported
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <patila@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>
Date: Wed, 07 Jan 2015 14:03:52 +0100
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC66736E7A69@SC-VEXCH2.marvell.com>
References: <1420475584-5533-1-git-send-email-patila@marvell.com>
	 (sfid-20150105_120344_381788_A7E15DA0),<1420462674.9459.9.camel@sipsolutions.net>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A69@SC-VEXCH2.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on our discussion, you don't actually want to support something
like off-channel CAC (which doesn't make much sense anyway), you just
have some issues with the carrier handling in the driver and bring up
the carrier ON by default rather than OFF.

I'll drop this completely for now.

johannes

