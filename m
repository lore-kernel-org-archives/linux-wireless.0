Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:26398
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376Ab2I0DXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 23:23:37 -0400
Message-ID: <5063C6B1.8030301@posedge.com> (sfid-20120927_052420_567198_E9721BDD)
Date: Thu, 27 Sep 2012 08:53:29 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: VHT peer STA caps
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF5269@mbx022-e1-nj-10.exch022.domain.local>     <1348477154.10257.2.camel@jlt4.sipsolutions.net>     <50614089.6020105@posedge.com>    <1348557902.10041.17.camel@jlt4.sipsolutions.net>    <50617E2C.6050000@posedge.com>   <1348582152.10041.36.camel@jlt4.sipsolutions.net>   <5062736B.9060008@posedge.com>  <1348660422.10548.10.camel@jlt4.sipsolutions.net>  <506339C3.40405@posedge.com> <1348682036.10548.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1348682036.10548.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/26/2012 11:23 PM, Johannes Berg wrote:
>
> Well struct ieee80211_sta is what the driver uses. That's where it's
> "telling" the driver, by making the data accessible to the driver. Your
> new vht_cap field there is also "telling the driver" that way.
>
Thanks for the pointer. will revert with code change.
>
>
> I don't think this makes sense, since we're talking only about a
> documentation change to your patch. See:
>
>    * @ht_cap: HT capabilities of this STA; restricted to our own TX capabilities
> + * @vht_cap: VHT capabilities of this STA
>
> The difference is that you don't say "restricted to own", but I think
> you should explicitly say that it isn't restricted.

Oh, I got it. Thanks Johannes.

Thanks
Mahesh
