Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35553 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbJWTbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 15:31:37 -0400
Received: by oifu63 with SMTP id u63so28751656oif.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2015 12:31:36 -0700 (PDT)
Subject: Re: overlap of devices in rtl8xxxu and rtl8192cu
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <562A2711.9040700@gmail.com> <wrfj7fmdit3l.fsf@redhat.com>
 <87ziz91xag.fsf@kamboji.qca.qualcomm.com> <wrfj611xhda9.fsf@redhat.com>
 <87oafp1pk6.fsf@kamboji.qca.qualcomm.com>
 <87k2qd1ooy.fsf@kamboji.qca.qualcomm.com> <wrfj1tcleajw.fsf@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <562A8B21.2020803@lwfinger.net> (sfid-20151023_213140_469582_42759878)
Date: Fri, 23 Oct 2015 14:31:45 -0500
MIME-Version: 1.0
In-Reply-To: <wrfj1tcleajw.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/23/2015 12:53 PM, Jes Sorensen wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
>> Kalle Valo <kvalo@codeaurora.org> writes:
>>
>>> Like I said earlier in rtl8xxxu review, I don't want to have two drivers
>>> supporting the same device. So either rtl8xxxu or rtlwifi supports the
>>> devices above, not both. And to my knowledge rtl8xxxu is still lacking
>>> in features, and it's a new driver, so it's best that rtlwifi continues
>>> to support these for the time being. Once rtl8xxxu catches up and we
>>> have a clear consensus we can make the switch.
>>>
>>> I'll send a patch in a jiffy, merge window is getting closer so we don't
>>> have any extra time.
>>
>> Heh, having hilarious problems with my patch:
>>
>> <linux-wireless@vger.kernel.org>: host vger.kernel.org[209.132.180.67] said:
>>      550 5.7.1 Content-Policy reject msg: The capital Triple-X in subject is way
>>      too often associated with junk email, please rephrase.
>>
>> The subject was:
>>
>> Subject: [PATCH] rtl8xxxu: move devices supported by rtlwifi under
>>   CONFIG_RTL8XXXU_UNTESTED
>
> This seems a reasonable workaround for now.
>
> Next time just add some extra buzzwords to the subject line and I am
> sure it will go through :)

Well, when you try to send porn, the system will complain. :)

I agree that this is a sensible workaround.

Larry


