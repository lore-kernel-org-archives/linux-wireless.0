Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47359 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab2ENNUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 09:20:32 -0400
Received: by qadb17 with SMTP id b17so2658650qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 06:20:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1335189878.27767.175.camel@wwguy-huron>
References: <CAFE89JyMHthxBuTcoMN_kOerrW+5yt8Sv1JyQRZATd-mzSwjvA@mail.gmail.com>
	<1335189878.27767.175.camel@wwguy-huron>
Date: Mon, 14 May 2012 16:20:30 +0300
Message-ID: <CAFE89JyAdTwTyWHmk0u7aQECWPREJUcDy_H5Bs5ySMTJAG4pgA@mail.gmail.com> (sfid-20120514_152059_843962_34BE83E7)
Subject: Re: laptop hangs while connecting to open wifi network
From: Oleksandr Yeremko <yeremko@gmail.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy,

thank you very much for your letter. Sorry for my long silence.

I solved the problem by moving to Ubuntu 12 with 3.2.0 kernel version.

Actually the problem was not only with wireless but with cardreader,
touchpad and screen brightness also. I think kernel 2.6.x does not
support chipset of Dell XPS notebook fully. And kernel 3.2.0 does
support.

Thank you very much again for your time.

Best regards,
Oleksandr


On Mon, Apr 23, 2012 at 5:04 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> Hi Oleksandr,
>
> On Mon, 2012-04-23 at 13:06 +0300, Oleksandr Yeremko wrote:
>> Dear All,
>>
>> I have Dell XPS laptop with Intel Corporation Centrino Wireless-N 1030 (rev 34).
>>
>> I use CentOS 6 with 2.6.32-220.7.1.el6.x86_64 kernel and iwlagn module.
>>
>> The problem is:
>> when I try to connect to any open wifi network my laptop hangs
>> (switching off is needed) and screen looses colors (like it is
>> switched to 256-colors mode).
>>
>> Does somebody have an idea how to solve this?
>>
> Could you provide more information, such as dmesg, lspci, ...
> also the configuration on your device, (open/secure, band,
> channel, ....)
>
> without more detail information, I am not sure how to help.
>
> Thanks
> Wey
>
>
