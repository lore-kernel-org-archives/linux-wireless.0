Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-6.exch022.serverdata.net ([206.225.164.189]:8754 "EHLO
	HUB022-nj-6.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753356Ab2JKJJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 05:09:36 -0400
Message-ID: <50768CC4.9030504@posedge.com> (sfid-20121011_110940_560575_E3359028)
Date: Thu, 11 Oct 2012 14:39:24 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] {nl,cfg}80211: Peer STA VHT caps
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCFB506@mbx022-e1-nj-10.exch022.domain.local> <1349945487.13097.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1349945487.13097.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2012 02:21 PM, Johannes Berg wrote:
> On Thu, 2012-10-11 at 08:04 +0000, Mahesh Palivela wrote:
>> From: Mahesh Palivela <maheshp@posedge.com>
>>
>> To save STAs VHT caps in AP mode
>
> Applied, thanks.
>
> Looks like we're getting close with VHT, what (besides a driver) are we
> missing?
>
> johannes
>

VHT regulatory and channel config are next items.
Extended CSA
Transmit power envelope
VHT rate handling
Beam forming
Quiet chan etc
