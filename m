Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38322 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845AbaLWMBa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 07:01:30 -0500
Message-ID: <1419336086.6091.4.camel@sipsolutions.net> (sfid-20141223_130133_743967_3A316407)
Subject: Re: [PATCH] cfg80211: do not check for carrier during
 start_radar_detect
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <patila@marvell.com>
Cc: "janusz.dziedzic@tieto.com" <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 23 Dec 2014 13:01:26 +0100
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC66736E7A39@SC-VEXCH2.marvell.com>
References: <CBACCFA0AEB13A41977475BCF3E896FC66736E7972@SC-VEXCH2.marvell.com>
	 <CALhHN=qA7icuY_MNvBebDsOMOkh6hEsWNkrZoGDGsQg+-f6Xog@mail.gmail.com>
	 ,<5FF020A1CFFEEC49BD1E09530C4FF5951B160B81A7@SC-VEXCH1.marvell.com>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A37@SC-VEXCH2.marvell.com>
	 ,<1419330394.6091.0.camel@sipsolutions.net>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A38@SC-VEXCH2.marvell.com>
	 <1419330994.6091.2.camel@sipsolutions.net>
	 (sfid-20141223_113642_547667_1737F2DD),<1419331030.6091.3.camel@sipsolutions.net>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A39@SC-VEXCH2.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-12-23 at 03:32 -0800, Avinash Patil wrote:
> Hi Johannes,
> 
> How about having a flag for offchannel CAC capability and check for
> netdev carrier state only when this capability is supported?

Yes, that seems appropriate.

(Btw, please don't top-post)

johannes

