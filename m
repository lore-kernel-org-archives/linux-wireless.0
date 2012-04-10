Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2382 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab2DJOTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 10:19:02 -0400
Message-ID: <4F844148.2010701@broadcom.com> (sfid-20120410_161917_654461_DE480086)
Date: Tue, 10 Apr 2012 16:18:48 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: brcmsmac on BCM47XX SoCs
References: <4F7F71A2.40105@hauke-m.de> <4F815181.6030007@broadcom.com>
 <CACna6rzSsQXxyMTX+-UJ-BuJ671avs8dVPOnOc1kSRW-3URvQg@mail.gmail.com>
 <4F82CE7B.8010803@hauke-m.de>
In-Reply-To: <4F82CE7B.8010803@hauke-m.de>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2012 01:56 PM, Hauke Mehrtens wrote:
> On 04/08/2012 09:54 PM, Rafał Miłecki wrote:
>> 2012/4/8 Arend van Spriel<arend@broadcom.com>:
>>> On 04/06/2012 11:43 PM, Hauke Mehrtens wrote:
>>>> What are your plans to support phy_ht in brcmsmac, for now it is just
>>>> supported by b43?
>>>
>>>
>>> I have not been paying good attention to community feedback on b43 phy_ht
>>> support. As b43 support bcm4331 with that phy we decided to stay clear from
>>> that device. We are to add new phy code for new devices. Not sure if that
>>> includes the phy_ht.
>>
>> Whoops, that's extremely too bad. HT support is really wanted for a
>> lot of routers. What we have in b43 is support coming from watching
>> mmio ops only, there is no way for it to be complete. I believe you
>> really should think and releasing HT PHY code, a lot of ppl will be
>> interested in that.
>>
> The TODO list for brcmsmac in the wireless wiki [0] says "Add support
> for more chips, including (near term) BCM43227, BCM43228, and BCM4331."
> The BCM4331 uses a HT-Phy, but b43 does not support 802.11n speed (the
> chip supports up to 450MBit/s) and 5GHz wifi and I do not think b43 will
> support these features in the near future, if it will ever support these
> features.

Yes. bcm4331 was/is on our TODO list, but when b43 added support for it 
we were unsure how to move forward.

> I do not think it is a big problem if brcmsmac supports some chips b43
> also supports as b43 misses some important features, for now some
> devices IDs for devices supported by brcmsmac and b43 they are
> deactivated in b43 by default so brcmsmac is used every time. I would
> like to see brcmsmac supporting all wifi chips using bcma (ai bus).

I am 100% with you and counting the votes I think we should add bcm4331 
as well ;-)

Gr. AvS

