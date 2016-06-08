Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34515 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbcFHP5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 11:57:01 -0400
MIME-Version: 1.0
In-Reply-To: <57583EFC.3070901@candelatech.com>
References: <1465388474-20503-1-git-send-email-prasunmaiti87@gmail.com>
 <87wplzkbd9.fsf@kamboji.qca.qualcomm.com> <CAEO8o4=DnEfXQAnAOxugC9TngbhvgV9DXz0HOVHNLk0B2fAXQA@mail.gmail.com>
 <87porrkaax.fsf@kamboji.qca.qualcomm.com> <CAEO8o4kD7MU09o+xOwPLn-PAgcuMExQ0MbNWgqv0fOs61rG8Xw@mail.gmail.com>
 <87d1nrk89v.fsf@kamboji.qca.qualcomm.com> <CAEO8o4=XEr4DQC3bqAXGE01s5WC+kuZ3PqoJFtuSCE52RNyDzA@mail.gmail.com>
 <57583EFC.3070901@candelatech.com>
From: Prasun Maiti <prasunmaiti87@gmail.com>
Date: Wed, 8 Jun 2016 21:26:59 +0530
Message-ID: <CAEO8o4=a54o0qvQ7ynQW=tJ95OY0_BiNYPP-5uj5jozDLQCp4Q@mail.gmail.com> (sfid-20160608_175723_959964_9CF2FD7F)
Subject: Re: [PATCH] Add .set_antenna callback in ath6kl driver to remove
 wireless core warns
To: Ben Greear <greearb@candelatech.com>
Cc: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	Linux Next <linux-next@vger.kernel.org>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please help me how to test this one?? It will be great to me if you help me.

On Wed, Jun 8, 2016 at 9:21 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 06/08/2016 08:46 AM, Prasun Maiti wrote:
>>
>> Please tell me if I mention that this code is untested in commit log,
>> then could you check the code kindly and also help me to fix this type
>> of warning?
>
>
> In my experience, ath6kl has very fragile and buggy firmware, so I would
> not add any new API to it unless you have tested this thoroughly.
>
> Thanks,
> Ben
>
>>
>> On Wed, Jun 8, 2016 at 9:00 PM, Valo, Kalle <kvalo@qca.qualcomm.com>
>> wrote:
>>>
>>> Prasun Maiti <prasunmaiti87@gmail.com> writes:
>>>
>>>> I am not sure it works fine. Like ath6kl driver send another cmd to
>>>> firmare, I have just filled up the cmd buffer with "tx_ant", and
>>>> "rx_ant" values, then use "ath6kl_wmi_cmd_send()" api to send the cmd
>>>> buffer to firmware. I have resend the patch as there are some errors
>>>> in the previous patch. Let me know if any modifications are needed?
>>>
>>>
>>> I don't take untested code. In some special cases it might be ok to send
>>> untested code but even then it needs to be clearly stated in the commit
>>> log that it's untested.
>>>
>>> Please resend once you have tested this, I'm dropping this now.
>>>
>>> --
>>> Kalle Valo
>>
>>
>>
>>
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>



-- 
Thanks,
Prasun
