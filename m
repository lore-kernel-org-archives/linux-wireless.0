Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44869 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaJSPEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2014 11:04:01 -0400
Received: by mail-wi0-f181.google.com with SMTP id hi2so4433260wib.2
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2014 08:03:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEf19C5DjK-Dod5HKKv2d6bNXgNAvjz+txZO1RQL8jzFDg@mail.gmail.com>
References: <CABPxzYJXPbmrfrgyoE5X9UO-3LQQVnXYtpz3x1Sd-fhts-Ns-g@mail.gmail.com>
 <CAB3XZEf19C5DjK-Dod5HKKv2d6bNXgNAvjz+txZO1RQL8jzFDg@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sun, 19 Oct 2014 20:33:39 +0530
Message-ID: <CABPxzY+0TZ8QQAC5k_zi-NaQNaB9T-QteE71Kux2dCay9ws5jA@mail.gmail.com> (sfid-20141019_170406_504169_ACF6DEDD)
Subject: Re: SMPS for AP mode confoguration
To: Eliad Peller <eliad@wizery.com>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 19, 2014 at 6:51 PM, Eliad Peller <eliad@wizery.com> wrote:
> hi,
>
> On Sun, Oct 19, 2014 at 2:50 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>> We are testing SMPS functionality for AP mode. The driver conveys its
>> capabilities through setting the HT capability which can be set to 0-3.
>>
>> I wanted to convey support for both Dynamic and Static Powersave
>> and then control the config through hostapd.conf file. Currently this is
>> not possible.From driver i can only advertize support for static (or) dynamic
>> not both (HW_SUPPORTS_* is a different thing which is used in
>> doing checks at debugfs level).
>>
>> So if i wanted to configure different modes from hostapd.conf, i
>> have to change the driver settings as well.
>>
>> Shouldn't it be the other way around, based on driver's _HW_ flags
>> we should convey the capabilities to user-space  (currently we use
>> ht_cap for this) and it will configure the mode from the configuration
>> file.  I think the design of SMPS configuration should be changed.
>>
> this was recently changed. take a look at this patchset:
> http://www.spinics.net/lists/linux-wireless/msg126749.html
>
> we also have a matching supplicant patchset that will probably be
> upstreamed soon.

Thanks Ellad, it looks good to me, will try out them once they are up stream.
