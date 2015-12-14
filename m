Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39928 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbbLNEA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2015 23:00:26 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linuxwifi <linuxwifi@intel.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi - L1 Enabled - LTR Enabled loop
Date: Mon, 14 Dec 2015 04:00:20 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E919DE2@hasmsx107.ger.corp.intel.com> (sfid-20151214_050030_063057_C757F64A)
References: <CAB=NE6U5sh4cneaB5CGC7fSM_fKG_tBtmZ6sAo9Jswm1RBzd-g@mail.gmail.com>
 <CAB=NE6VFo96M-ieCYPeDKncGJm+G1-_4gqKNDFen+K49-pLD4Q@mail.gmail.com>
 <1449876779.2324.16.camel@sipsolutions.net> <566DF964.7050904@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/14/2015 01:04 AM, Arend van Spriel wrote:
> On 12/12/2015 12:32 AM, Johannes Berg wrote:
>> On Fri, 2015-12-11 at 15:17 -0800, Luis R. Rodriguez wrote:
>>> I just tried a base config from opensuse, then localmodconfig, then
>>> 'make xenconfig' (which I need) and that worked. I can't debug
>>> further but I think this config might help debug this further:
>>>
>>> http://drvbp1.linux-foundation.org/~mcgrof/tmp/config-iwl-fail.txt
>>>
>>> So -- my new config works, but I have no idea what fixed it, a config
>>> option obviously. Not sure what though.
>>>
>> Can you post the good one too?
> I had the same issue occasionally when coming out of suspend. Running 
> 4.1 vanilla kernel with 3160 device. The issue also occurred more often 
> with particular ucode version. Running iwlwifi-3160-10.ucode now and 
> have not seen the issue pop up since.

This is really weird. I don't see how that could be firmware related.
BTW, -10.ucode is fairly old :) we have -16.ucode out there.
>
> Gr. AvS
>
>

