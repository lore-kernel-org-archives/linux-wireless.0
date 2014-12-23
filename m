Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30876 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbaLWKdB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 05:33:01 -0500
From: Avinash Patil <patila@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "janusz.dziedzic@tieto.com" <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 23 Dec 2014 02:30:13 -0800
Subject: RE: [PATCH] cfg80211: do not check for carrier during
 start_radar_detect
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66736E7A38@SC-VEXCH2.marvell.com> (sfid-20141223_113305_118990_DC6877B0)
References: <CBACCFA0AEB13A41977475BCF3E896FC66736E7972@SC-VEXCH2.marvell.com>
	 <CALhHN=qA7icuY_MNvBebDsOMOkh6hEsWNkrZoGDGsQg+-f6Xog@mail.gmail.com>
	,<5FF020A1CFFEEC49BD1E09530C4FF5951B160B81A7@SC-VEXCH1.marvell.com>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A37@SC-VEXCH2.marvell.com>,<1419330394.6091.0.camel@sipsolutions.net>
In-Reply-To: <1419330394.6091.0.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oops..

Are you talking about this?
>>So, at least we should move if (netif_carrier_ok(dev)) check to mac80211 otherwise we might change channel of the running interface (via vif_use_channel).

I can move this check to ieee80211_start_radar_detection but I dont have any hardware to test these modifications.

Thanks,
Avinash
________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Tuesday, December 23, 2014 3:56 PM
To: Avinash Patil
Cc: janusz.dziedzic@tieto.com; linux-wireless@vger.kernel.org; Cathy Luo; Amitkumar Karwar
Subject: Re: [PATCH] cfg80211: do not check for carrier during start_radar_detect

On Tue, 2014-12-23 at 02:13 -0800, Avinash Patil wrote:
> Hi Janusz,
>
> Any further update on this?

We were waiting for you to send a new patch?

johannes

