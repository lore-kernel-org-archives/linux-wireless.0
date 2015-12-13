Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:51163 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbbLMXEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2015 18:04:07 -0500
Message-ID: <566DF964.7050904@broadcom.com> (sfid-20151214_000414_137413_D5E9737C)
Date: Mon, 14 Dec 2015 00:04:04 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi - L1 Enabled - LTR Enabled loop
References: <CAB=NE6U5sh4cneaB5CGC7fSM_fKG_tBtmZ6sAo9Jswm1RBzd-g@mail.gmail.com>	 <CAB=NE6VFo96M-ieCYPeDKncGJm+G1-_4gqKNDFen+K49-pLD4Q@mail.gmail.com>	 (sfid-20151212_001801_158339_DCC9E024) <1449876779.2324.16.camel@sipsolutions.net>
In-Reply-To: <1449876779.2324.16.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/2015 12:32 AM, Johannes Berg wrote:
> On Fri, 2015-12-11 at 15:17 -0800, Luis R. Rodriguez wrote:
>>
>> I just tried a base config from opensuse, then localmodconfig, then
>> 'make xenconfig' (which I need) and that worked. I can't debug
>> further but I think this config might help debug this further:
>>
>> http://drvbp1.linux-foundation.org/~mcgrof/tmp/config-iwl-fail.txt
>>
>> So -- my new config works, but I have no idea what fixed it, a config
>> option obviously. Not sure what though.
>>
>
> Can you post the good one too?

I had the same issue occasionally when coming out of suspend. Running 
4.1 vanilla kernel with 3160 device. The issue also occurred more often 
with particular ucode version. Running iwlwifi-3160-10.ucode now and 
have not seen the issue pop up since.

Gr. AvS

