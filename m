Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2250 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab1C2PMn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 11:12:43 -0400
Message-ID: <4D91F6DA.50808@canonical.com>
Date: Tue, 29 Mar 2011 09:12:26 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: wwguy <wey-yi.w.guy@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.38 iwlwifi 11n_disable=1
References: <4D8CB794.9040102@canonical.com> <1301067874.9139.7.camel@wwguy-ubuntu>
In-Reply-To: <1301067874.9139.7.camel@wwguy-ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/25/2011 09:44 AM, wwguy wrote:
> Hi Tim,
>
> On Fri, 2011-03-25 at 08:41 -0700, Tim Gardner wrote:
>> Wey-Yi,
>>
>> The Ubuntu Maverick release (2.6.35) has been carrying a user space
>> patch in module-init-tools that disables 802.11n support by default
>> using the 11n_disable module parameter. With the split in 2.6.38 into
>> iwl3945 and iwlagn is it possible that we could now remove the module
>> option for iwlagn? Will the 4965 adapters function correctly with 802.11n?
>>
>
> with both the driver split and new 5000 uCode available at
> (http://www.intellinuxwireless.org/?n=Downloads)
>
> I believe we are in very good shape to have 11n support for both legacy
> and agn devices. (yes 4965 will have 11n support)
>
> Please remove the module option to disable 11n support.
>
> Thank you very much for the help.
>
> Wey
>
>

It seems that not everyone's experience has been superior: 
https://bugs.launchpad.net/ubuntu/+source/linux-firmware/+bug/630748/comments/70

I'm enabling 802.11n support for non-legacy iwlwifi devices in natty for 
now. We'll see how it works out.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
