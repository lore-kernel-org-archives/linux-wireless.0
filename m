Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:43172
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410Ab2IZDQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:16:00 -0400
Message-ID: <5062736B.9060008@posedge.com> (sfid-20120926_051605_351946_F0256572)
Date: Wed, 26 Sep 2012 08:45:55 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: VHT peer STA caps
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF5269@mbx022-e1-nj-10.exch022.domain.local>   <1348477154.10257.2.camel@jlt4.sipsolutions.net>   <50614089.6020105@posedge.com>  <1348557902.10041.17.camel@jlt4.sipsolutions.net>  <50617E2C.6050000@posedge.com> <1348582152.10041.36.camel@jlt4.sipsolutions.net>
In-Reply-To: <1348582152.10041.36.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/25/2012 07:39 PM, Johannes Berg wrote:
>
> Well imagine you have a driver for some hardware that can do
> beamforming, and the same driver can also work with hardware that
> doesn't. If we restrict remote caps, like we do for HT, the driver
> doesn't have to worry about this but can just do whatever the remote
> caps say is possible. If we don't restrict it, the driver has to also
> check its own caps.

you mean to say some drivers which dont provide its own VHT caps, will 
use remote STA VHT caps as its own?
If so I feel not correct posing remote STA caps as local caps.

>
> We can do this, and I suspect it will be simpler, but it needs to be
> *very clearly* documented since VHT will then be different from HT.
>
> johannes
>
