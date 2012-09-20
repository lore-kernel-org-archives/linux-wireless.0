Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55210 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2ITKhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 06:37:48 -0400
Received: by ieak13 with SMTP id k13so3110748iea.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2012 03:37:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <503318FD.7070108@qca.qualcomm.com>
References: <CC53EBAA.16239%sunil2@telenetsystems.com>
	<503318FD.7070108@qca.qualcomm.com>
Date: Thu, 20 Sep 2012 16:07:47 +0530
Message-ID: <CAEZZmbG78oO5_D3zncanXStYpuf_faoqq6rp3usPpd3_5+tBQA@mail.gmail.com> (sfid-20120920_123752_525719_D34FCEAF)
Subject: Re: [ath9k-devel] :
From: Ravi Sharma <sharmaravi.lx@gmail.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: Sunil Mehta <sunil2@telenetsystems.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Mohammed@venema.h4ckr.net,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org,
	Felix Bitterli <felixb@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to setup concurrent mode for TL-WL722N (TP-LINK) (ath9k)
and upgraded& used the driver with the latest compat release. I am
trying to run STA & P2P concurrently with two supplicant. Is this
configuration possible?



I am using Ubuntu with kernel 3.2

Can you please share the setup you are using to validate the ath9k
mac80211 for concurrent mode?

Regards,
Ravi

On Tue, Aug 21, 2012 at 10:43 AM, Mohammed Shafi Shajakhan
<mohammed@qca.qualcomm.com> wrote:
> Hi,
>
>
> On Friday 17 August 2012 12:42 PM, Sunil Mehta wrote:
>>>
>>>
>>> Hi
>>
>>
>> We are using AR9331 and are currently using the device in - AP mode, and
>> Station mode.
>>
>> We would like to use the device for a P2P application. Can you suggest
>> what we need to do.
>
>
> sorry for the delayed reply, i was on leave(did not check any mails!) for
> the past 6 days.
>
> please read this and check this out, if it helps and works for you
> http://linuxwireless.org/en/developers/p2p/howto.
>
> please let me know if there any basic configuration issues.
>
> technical issues related to p2p are discussed in hostap mailing lists
> http://lists.shmoo.com/mailman/listinfo/hostap
>
>
>
>>
>> Regards,
>> Sunil.
>>
>>
>
>
> --
> thanks,
> shafi
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
