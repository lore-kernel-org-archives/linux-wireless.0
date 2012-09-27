Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:20531
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729Ab2I0Ge5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 02:34:57 -0400
Message-ID: <5063F372.2040601@posedge.com> (sfid-20120927_083501_081361_49E0633D)
Date: Thu, 27 Sep 2012 12:04:26 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: VHT peer STA caps
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF5269@mbx022-e1-nj-10.exch022.domain.local>      <1348477154.10257.2.camel@jlt4.sipsolutions.net>      <50614089.6020105@posedge.com>     <1348557902.10041.17.camel@jlt4.sipsolutions.net>     <50617E2C.6050000@posedge.com>    <1348582152.10041.36.camel@jlt4.sipsolutions.net>    <5062736B.9060008@posedge.com>   <1348660422.10548.10.camel@jlt4.sipsolutions.net>   <506339C3.40405@posedge.com>  <1348682036.10548.13.camel@jlt4.sipsolutions.net>  <5063C6B1.8030301@posedge.com> <1348727075.10353.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1348727075.10353.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2012 11:54 AM, Johannes Berg wrote:
>> Thanks for the pointer. will revert with code change.
>
> Well, reverting that change would be pointless?
>
> Better just add some text there to the docs.
>

Sorry wrong usage of word revert. what I meant was get back with proper 
mask bits code change.
Also update docs section accordingly.
