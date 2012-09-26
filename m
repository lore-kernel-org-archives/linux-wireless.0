Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-4.exch022.serverdata.net ([206.225.164.187]:15942
	"EHLO HUB022-nj-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932121Ab2IZRWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 13:22:14 -0400
Message-ID: <506339C3.40405@posedge.com> (sfid-20120926_192221_375013_A606C0EC)
Date: Wed, 26 Sep 2012 22:52:11 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: VHT peer STA caps
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF5269@mbx022-e1-nj-10.exch022.domain.local>    <1348477154.10257.2.camel@jlt4.sipsolutions.net>    <50614089.6020105@posedge.com>   <1348557902.10041.17.camel@jlt4.sipsolutions.net>   <50617E2C.6050000@posedge.com>  <1348582152.10041.36.camel@jlt4.sipsolutions.net>  <5062736B.9060008@posedge.com> <1348660422.10548.10.camel@jlt4.sipsolutions.net>
In-Reply-To: <1348660422.10548.10.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/26/2012 5:23 PM, Johannes Berg wrote:
>> you mean to say some drivers which dont provide its own VHT caps, will
>> use remote STA VHT caps as its own?
>> If so I feel not correct posing remote STA caps as local caps.
>
> No, no. If you look at HT, then you'll see that if the driver has HT but
> isn't capable of doing everything the peer STA can do, then mac80211
> restricts tells the driver

Sorry. Where is it telling the driver? I couldn't find this part of code 
in mac80211, could you point me?

> only about the peer capabilities that the
> device can do as well.
>
> I agree that this isn't really necessary and can be rather complex in
> VHT, but I think you need to document the difference very clearly in the
> documentation for the ieee80211_sta VHT caps.

Can this go as different patch? take my v2 patch as framework. More 
implementation of vht.c at later point of time?

>
> johannes
>

-- 
Thanks,
Mahesh
