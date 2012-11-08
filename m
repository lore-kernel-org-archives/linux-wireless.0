Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:54537 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208Ab2KHP7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 10:59:52 -0500
Received: by mail-ia0-f174.google.com with SMTP id y32so2016682iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2012 07:59:51 -0800 (PST)
Message-ID: <509BD6F3.2000807@lwfinger.net> (sfid-20121108_170005_097341_F3279799)
Date: Thu, 08 Nov 2012 09:59:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Nonaka Akira <nonaka@mac.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: "mac80211.ko" and "cfg80211.ko" compatibility issue.
References: <509B73D5.5000206@mac.com> <CAGRGNgUB_7NZTnC2k2_f0_bAP0yu4cXTqk3_QpxpKZHqw__+hw@mail.gmail.com> <9983E05C-2103-49C8-A675-4F5368F53FB5@mac.com> <CAGRGNgXj2rkiHw1D4HqRCyX6yJCDq75k1KtS0OR+t4En+wa_jA@mail.gmail.com>
In-Reply-To: <CAGRGNgXj2rkiHw1D4HqRCyX6yJCDq75k1KtS0OR+t4En+wa_jA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2012 06:20 AM, Julian Calaby wrote:
> Hi Nonaka,
>
> On Thu, Nov 8, 2012 at 10:33 PM, Nonaka Akira <nonaka@mac.com> wrote:
>> Hi Julian,
>>
>> Well, We consider the option of using the entire compat-wireless drivers. However, we are planning the minor update of our product toward the end of the year and I thought it will be nice if I can keep the change minimum.
>
> In general, the drivers in compat-wireless are more stable and have
> more features than the versions in older kernels. (it is a back-port
> of newer wireless drivers after all)
>
> I would expect that you'll spend more time working out a solution to
> use it for a single driver than you'd spend testing it on the hardware
> you intend to support.

I agree. If you want to change only rtl8723ae, then you will need to backport it 
to kernel 3.4.9 yourself. I have no idea how much work that would be, but I have 
no interest in doing it.

Larry


