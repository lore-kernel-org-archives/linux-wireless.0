Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42142 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451Ab1ISTDU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 15:03:20 -0400
Message-ID: <4E7791F5.5050709@openwrt.org> (sfid-20110919_210323_871349_340A5FD9)
Date: Mon, 19 Sep 2011 21:03:17 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH v2 3/4] ath: remove ath_regulatory::current_rd_ext
References: <1316453903-75710-1-git-send-email-nbd@openwrt.org> <1316453903-75710-2-git-send-email-nbd@openwrt.org> <1316453903-75710-3-git-send-email-nbd@openwrt.org> <CAB=NE6UhC=am2aVXwf+v4g7ME_49Nv47SZwSNetLgJpRV-=BkA@mail.gmail.com> <4E778A1C.5020206@openwrt.org> <CAB=NE6WLfhEb0X4u9g87oE3poNzPmKr-Z8H554tZ_erJ8-rRjg@mail.gmail.com> <4E779076.2030509@openwrt.org> <CAB=NE6UtJ=7X84iruquCSGhaj_SDKEWe_5iAnwGyRg94ggugWA@mail.gmail.com>
In-Reply-To: <CAB=NE6UtJ=7X84iruquCSGhaj_SDKEWe_5iAnwGyRg94ggugWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-19 8:58 PM, Luis R. Rodriguez wrote:
> On Mon, Sep 19, 2011 at 11:56 AM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>  On 2011-09-19 8:43 PM, Luis R. Rodriguez wrote:
>>>
>>>  On Mon, Sep 19, 2011 at 11:29 AM, Felix Fietkau<nbd@openwrt.org>    wrote:
>>>>
>>>>    On 2011-09-19 8:18 PM, Luis R. Rodriguez wrote:
>>>>>
>>>>>    On Mon, Sep 19, 2011 at 10:38 AM, Felix Fietkau<nbd@openwrt.org>
>>>>>    wrote:
>>>>>>
>>>>>>     Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>>>>
>>>>>    Can you document on the patch commit log why you do remove this.
>>>>
>>>>    Because it's unused
>>>
>>>  Why is it unused?
>>
>>  Because the code that used to use it was removed a while ago in other
>>  patches.
>
> And what did that do :) ?
It used to set some pointless flags that were never used for anything.

- Felix
