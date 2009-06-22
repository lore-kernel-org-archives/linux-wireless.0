Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:55855 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZFVUS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 16:18:28 -0400
Received: from [10.0.0.2] (ool-4573a3fb.dyn.optonline.net [69.115.163.251])
 by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KLN00LQHPQOEYL0@mta3.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Mon, 22 Jun 2009 16:18:25 -0400 (EDT)
Date: Mon, 22 Jun 2009 16:18:24 -0400
From: Darren Blaber <dmbtech@gmail.com>
Subject: Re: iwl3945 not working after recent commits
In-reply-to: <1245690182.24303.488.camel@rc-desk>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-id: <4A3FE710.7090408@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <4A3C2036.6060506@gmail.com>
 <43e72e890906191642kbcca090we1b03db19bf0e2c8@mail.gmail.com>
 <4A3C4593.6050707@gmail.com>
 <43e72e890906191915g2c9736f2i4633c8ed3766fe3b@mail.gmail.com>
 <4A3C4745.7000706@gmail.com>
 <43e72e890906191924m2f83815fp860c0a277e44d2e1@mail.gmail.com>
 <87ws77o76m.fsf@litku.valot.fi>
 <43e72e890906192221p5cc67d28gb14b214bbf252ad@mail.gmail.com>
 <1245690182.24303.488.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre wrote:
> On Fri, 2009-06-19 at 22:21 -0700, Luis R. Rodriguez wrote:
>   
>> On Fri, Jun 19, 2009 at 9:33 PM, Kalle Valo<kalle.valo@iki.fi> wrote:
>>     
>>> "Luis R. Rodriguez" <mcgrof@gmail.com> writes:
>>>
>>>       
>>>>> I'm using 2.6.30 with the KMS radeon patches, don't know if that is
>>>>> interfering. I'll try wireless-testing directly.
>>>>>           
>>>> Yeah this is odd, 2.6.30 shouldn't have an issue with backport unless
>>>> I'm missing something. Let us know how it goes with wireless-testing.
>>>>         
>>> I'm using latest wireles-testing and I have iwl3945 on my X60s. iwl3945
>>> is working fine for me.
>>>       
>> Yeah the user tried a vanilla 2.6.30 and it seems to be working fine
>> now, it seems related to kms somehow.
>>     
>
> Darren also submitted a kernel.org (#13585) bug which was closed by
> himself with reason "Turns out it was a bad development kernel from
> ubuntu.".
>
> Reinette
>
>
>   
Yes, sorry, I should of commented on this list also. Turns out the 
reason it wasn't detecting was do due a bad kernel package.
