Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1952 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbbAGNOO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 08:14:14 -0500
From: Avinash Patil <patila@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>
Date: Wed, 7 Jan 2015 05:12:57 -0800
Subject: RE: [PATCH v3] cfg80211: check for carrier state only when
 offchanel CAC supported
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66736E7A82@SC-VEXCH2.marvell.com> (sfid-20150107_141417_842824_13E36D91)
References: <1420475584-5533-1-git-send-email-patila@marvell.com>
	 (sfid-20150105_120344_381788_A7E15DA0),<1420462674.9459.9.camel@sipsolutions.net>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A69@SC-VEXCH2.marvell.com>,<1420635832.3407.7.camel@sipsolutions.net>
In-Reply-To: <1420635832.3407.7.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sure Johannes.

We need to fix carrier state handling in ndo_open and this patch would not be needed.

Thanks,
Avinash
________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Wednesday, January 07, 2015 6:33 PM
To: Avinash Patil
Cc: linux-wireless@vger.kernel.org; Amitkumar Karwar; Cathy Luo
Subject: Re: [PATCH v3] cfg80211: check for carrier state only when offchanel CAC supported

Based on our discussion, you don't actually want to support something
like off-channel CAC (which doesn't make much sense anyway), you just
have some issues with the carrier handling in the driver and bring up
the carrier ON by default rather than OFF.

I'll drop this completely for now.

johannes

