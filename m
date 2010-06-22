Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2663 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab0FVAOc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 20:14:32 -0400
Message-ID: <4C200059.1090100@canonical.com>
Date: Mon, 21 Jun 2010 18:14:17 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, j@w1.fi
Subject: Re: 2.6.35-rc3: Reported regressions 2.6.33 -> 2.6.34
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera> <AANLkTinRKbRPPzEqhdcexISRJKViBldG01cj9aF0wPx-@mail.gmail.com> 	<1277157673.24550.5.camel@mj> <AANLkTinRqbLH1NOx0o8GNfMaCa1N9NxlsqNzWZWzEyQt@mail.gmail.com>
In-Reply-To: <AANLkTinRqbLH1NOx0o8GNfMaCa1N9NxlsqNzWZWzEyQt@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/2010 04:18 PM, Luis R. Rodriguez wrote:
> On Mon, Jun 21, 2010 at 3:01 PM, Pavel Roskin<proski@gnu.org>  wrote:
>> On Mon, 2010-06-21 at 11:32 -0700, Luis R. Rodriguez wrote:
>>
>>>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16111
>>>> Subject         : hostap_pci: infinite registered netdevice wifi0
>>>> Submitter       : Petr Pisar<petr.pisar@atlas.cz>
>>>> Date            : 2010-06-02 20:55 (19 days old)
>>>
>>> The last entry on this one says we are not sure how to fix this...
>>
>> That was a patch posted for that by Tim Gardner:
>> https://patchwork.kernel.org/patch/105008/
>>
>> The patch is applied to wireless-testing
>> (d6a574ff6bfb842bdb98065da053881ff527be46)
>>
>> $ git describe d6a574ff6bfb842bdb98065da053881ff527be46
>> v2.6.34-4694-gd6a574f
>>
>> I understand it was applied after 2.6.34, so it should be backported to
>> 2.6.34 and whatever older kernels are affected.
>
> Tim can this be sent for stable?
>
>    Luis, a stable whore
>

Luis,

The patch that I sent John is already Cc stable@kernel.org, though it 
may not now apply after 56bf882230d2266a2e07b7f404dc96d157a65daa 'Revert 
"wireless: hostap, fix oops due to early probing interrupt"'. I'll check 
in the morning and craft a backported patch if necessary.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
