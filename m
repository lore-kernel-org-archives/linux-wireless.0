Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbbJWRxZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 13:53:25 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: overlap of devices in rtl8xxxu and rtl8192cu
References: <562A2711.9040700@gmail.com> <wrfj7fmdit3l.fsf@redhat.com>
	<87ziz91xag.fsf@kamboji.qca.qualcomm.com>
	<wrfj611xhda9.fsf@redhat.com>
	<87oafp1pk6.fsf@kamboji.qca.qualcomm.com>
	<87k2qd1ooy.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 23 Oct 2015 13:53:23 -0400
In-Reply-To: <87k2qd1ooy.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Fri, 23 Oct 2015 20:26:21 +0300")
Message-ID: <wrfj1tcleajw.fsf@redhat.com> (sfid-20151023_195331_118200_A525EA31)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Kalle Valo <kvalo@codeaurora.org> writes:
>
>> Like I said earlier in rtl8xxxu review, I don't want to have two drivers
>> supporting the same device. So either rtl8xxxu or rtlwifi supports the
>> devices above, not both. And to my knowledge rtl8xxxu is still lacking
>> in features, and it's a new driver, so it's best that rtlwifi continues
>> to support these for the time being. Once rtl8xxxu catches up and we
>> have a clear consensus we can make the switch.
>>
>> I'll send a patch in a jiffy, merge window is getting closer so we don't
>> have any extra time.
>
> Heh, having hilarious problems with my patch:
>
> <linux-wireless@vger.kernel.org>: host vger.kernel.org[209.132.180.67] said:
>     550 5.7.1 Content-Policy reject msg: The capital Triple-X in subject is way
>     too often associated with junk email, please rephrase.
>
> The subject was:
>
> Subject: [PATCH] rtl8xxxu: move devices supported by rtlwifi under
>  CONFIG_RTL8XXXU_UNTESTED

This seems a reasonable workaround for now.

Next time just add some extra buzzwords to the subject line and I am
sure it will go through :)

Jes
