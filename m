Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nk11p00mm-asmtp007.mac.com ([17.158.161.6]:58332 "EHLO
	nk11p00mm-asmtp007.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753976Ab2KIAhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 19:37:00 -0500
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Received: from [10.20.200.168]
 (p3027-ipbf5206marunouchi.tokyo.ocn.ne.jp [118.8.142.27])
 by nk11p00mm-asmtp007.mac.com
 (Oracle Communications Messaging Server 7u4-26.01(7.0.4.26.0) 64bit (built Jul
 13 2012)) with ESMTPSA id <0MD700B3R31LXS70@nk11p00mm-asmtp007.mac.com> for
 linux-wireless@vger.kernel.org; Fri, 09 Nov 2012 00:37:00 +0000 (GMT)
Message-id: <509C5019.3040002@mac.com> (sfid-20121109_013716_037960_CAB34406)
Date: Fri, 09 Nov 2012 09:36:41 +0900
From: Akira Nonaka <nonaka@mac.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: "mac80211.ko" and "cfg80211.ko" compatibility issue.
References: <509B73D5.5000206@mac.com>
 <CAGRGNgUB_7NZTnC2k2_f0_bAP0yu4cXTqk3_QpxpKZHqw__+hw@mail.gmail.com>
 <9983E05C-2103-49C8-A675-4F5368F53FB5@mac.com>
 <CAGRGNgXj2rkiHw1D4HqRCyX6yJCDq75k1KtS0OR+t4En+wa_jA@mail.gmail.com>
 <509BD6F3.2000807@lwfinger.net>
In-reply-to: <509BD6F3.2000807@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian, Larry

Thank you for your advise. I will consider taking your suggestion.

Akira


(2012/11/09 0:59), Larry Finger wrote:
> On 11/08/2012 06:20 AM, Julian Calaby wrote:
>> Hi Nonaka,
>>
>> On Thu, Nov 8, 2012 at 10:33 PM, Nonaka Akira <nonaka@mac.com> wrote:
>>> Hi Julian,
>>>
>>> Well, We consider the option of using the entire compat-wireless
>>> drivers. However, we are planning the minor update of our product
>>> toward the end of the year and I thought it will be nice if I can
>>> keep the change minimum.
>>
>> In general, the drivers in compat-wireless are more stable and have
>> more features than the versions in older kernels. (it is a back-port
>> of newer wireless drivers after all)
>>
>> I would expect that you'll spend more time working out a solution to
>> use it for a single driver than you'd spend testing it on the hardware
>> you intend to support.
>
> I agree. If you want to change only rtl8723ae, then you will need to
> backport it to kernel 3.4.9 yourself. I have no idea how much work that
> would be, but I have no interest in doing it.
>
> Larry
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Akira Nonaka
