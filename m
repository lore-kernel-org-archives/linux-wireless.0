Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:43763 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877Ab0AXVHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 16:07:39 -0500
Message-ID: <4B5CB687.3060106@redfish-solutions.com>
Date: Sun, 24 Jan 2010 13:07:19 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kalle.valo@iki.fi>, Pavel Roskin <proski@gnu.org>,
	Markus Baier <markus_baier@web.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Starting hostapd causes kernel panic
References: <loom.20100122T205326-794@post.gmane.org>	 <1264193623.2593.17.camel@johannes.local> <1264196526.3040.3.camel@mj>	 <3ef14e53bb12298507dbaec4bb0b98d3.squirrel@secure.sipsolutions.net>	 <1264197963.9056.0.camel@mj> <1264251576.2593.30.camel@johannes.local>	 <4B5B6FCA.2070900@redfish-solutions.com> <87aaw4oxh0.fsf@purkki.valot.fi>	 <4B5C0173.9080100@redfish-solutions.com> <1264333341.23766.25.camel@johannes.local>
In-Reply-To: <1264333341.23766.25.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2010 03:42 AM, Johannes Berg wrote:
> On Sun, 2010-01-24 at 00:14 -0800, Philip A. Prindeville wrote:
>> On 01/23/2010 09:58 PM, Kalle Valo wrote:
>>> "Philip A. Prindeville" <philipp_subx@redfish-solutions.com> writes:
>>>
>>>>>> Whatever you prefer.  Either way, the panic is fixed now!
>>>>>>     
>>>>> Great, and sorry about that! I'll send a patch to insert the else too.
>>>>>
>>>>> johannes
>>>>>   
>>>>
>>>> Did you send that patch? I'd like to apply it. Please copy me when
>>>> you send it out.
>>>
>>> Johannes was busy and I sent the patch instead. It's here:
>>>
>>> http://marc.info/?l=linux-wireless&m=126427124317427&w=2
>>>
>>
>> I just applied it to compat-wireless-2010-01-20 and ran it on an AR5413 but it still panics:
>>
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000019f
>> IP: [<e0993e7f>] :mac80211:invoke_tx_handlers+0x5be/0xe6a
>> *pde = 00000000
>> Oops: 0000 [#1] PREEMPT
> 
>> Pid: 1652, comm: hostapd Tainted: P          (2.6.27.42-astlinux #1)
>> EIP: 0060:[<e0993e7f>] EFLAGS: 00010246 CPU: 0
>> EIP is at invoke_tx_handlers+0x5be/0xe6a [mac80211]
> 
> Are you sure you reloaded the modules etc. correctly? Kinda looks like
> the same issue. Otherwise can you send me in private your mac80211.ko
> and hostapd config file?
> 
> johannes


Just to be sure I applied all of the correct patches, can you please send me the list again?

Kalle mentioned there being more than one.

Thanks.
