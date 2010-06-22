Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36411 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab0FVA0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 20:26:44 -0400
Received: by pwj8 with SMTP id 8so582477pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 17:26:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C200059.1090100@canonical.com>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera> <AANLkTinRKbRPPzEqhdcexISRJKViBldG01cj9aF0wPx-@mail.gmail.com>
	<1277157673.24550.5.camel@mj> <AANLkTinRqbLH1NOx0o8GNfMaCa1N9NxlsqNzWZWzEyQt@mail.gmail.com>
	<4C200059.1090100@canonical.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 21 Jun 2010 17:26:20 -0700
Message-ID: <AANLkTilQSFWP7DABswlOqUOq1yjFQG6RwFzkOIY6zl4i@mail.gmail.com>
Subject: Re: 2.6.35-rc3: Reported regressions 2.6.33 -> 2.6.34
To: tim.gardner@canonical.com
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, j@w1.fi
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 21, 2010 at 5:14 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> On 06/21/2010 04:18 PM, Luis R. Rodriguez wrote:
>>
>> On Mon, Jun 21, 2010 at 3:01 PM, Pavel Roskin<proski@gnu.org>  wrote:
>>>
>>> On Mon, 2010-06-21 at 11:32 -0700, Luis R. Rodriguez wrote:
>>>
>>>>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16111
>>>>> Subject         : hostap_pci: infinite registered netdevice wifi0
>>>>> Submitter       : Petr Pisar<petr.pisar@atlas.cz>
>>>>> Date            : 2010-06-02 20:55 (19 days old)
>>>>
>>>> The last entry on this one says we are not sure how to fix this...
>>>
>>> That was a patch posted for that by Tim Gardner:
>>> https://patchwork.kernel.org/patch/105008/
>>>
>>> The patch is applied to wireless-testing
>>> (d6a574ff6bfb842bdb98065da053881ff527be46)
>>>
>>> $ git describe d6a574ff6bfb842bdb98065da053881ff527be46
>>> v2.6.34-4694-gd6a574f
>>>
>>> I understand it was applied after 2.6.34, so it should be backported to
>>> 2.6.34 and whatever older kernels are affected.
>>
>> Tim can this be sent for stable?
>>
>>   Luis, a stable whore
>>
>
> Luis,
>
> The patch that I sent John is already Cc stable@kernel.org, though it may
> not now apply after 56bf882230d2266a2e07b7f404dc96d157a65daa 'Revert
> "wireless: hostap, fix oops due to early probing interrupt"'. I'll check in
> the morning and craft a backported patch if necessary.

Sweet thanks for the heads up!

  Luis
