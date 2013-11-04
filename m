Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60655 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab3KDQXB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 11:23:01 -0500
Received: by mail-oa0-f45.google.com with SMTP id i4so7375708oah.18
        for <linux-wireless@vger.kernel.org>; Mon, 04 Nov 2013 08:23:00 -0800 (PST)
Message-ID: <5277C9E3.3080702@lwfinger.net> (sfid-20131104_172313_904964_F85A473D)
Date: Mon, 04 Nov 2013 10:22:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	alexandre.f.demers@gmail.com, linville@tuxdriver.com
Subject: Re: r92su: status and will it be merged anytime soon?
References: <5277AC85.5050104@gmail.com> <5277BE84.7020808@lwfinger.net> <5277C604.1050604@gmail.com>
In-Reply-To: <5277C604.1050604@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2013 10:06 AM, Xose Vazquez Perez wrote:
> On 11/04/2013 04:34 PM, Larry Finger wrote:
>
>>> _anything_ is better than a staging driver.
>>>
>>> There are distributions that don't build staging drivers.
>>
>> As a result, they force their users to build out-of-tree drivers!
>
> reformulating: As a result, they force their users to _have a stable kernel_

Not all staging drivers are unstable, just as not all regular drivers are stable.

> Staging is only a working area. And the rtl8712-TODO is unreal:
> - merge Realtek's bugfixes and new features into the driver
> - switch to use LIB80211
> - switch to use MAC80211
> - checkpatch.pl fixes - only a few remain
>
>>> So, please, replace and delete staging/rtl8712 with r92su.
>>
>> You seem not to understand. Any new wireless driver that does not
>> use mac80211 *must* go into staging. AFAIK, that rule is absolute,
>                                                ^^^^^^^^^^^^^^^^^^^^^
>> and r92su cannot go into the regular wireless tree.
>
> Who said that ? Then replace staging/rtl8712 with staging/r92su
>
> Anyway, r92su is a _linux_ driver with a cfg80211 interface.
> staging/rtl8712 is crap?
>
> 1152k    drivers/staging/rtl8712/
> 340k     r92su/
>
>> If you do not like having drivers for RTL8192SU in staging, then
>> write one that uses mac80211. You have access to as much information
>> about the chips as anyone outside Realtek. They have no interest
>> in doing the mac80211 version, and I have many other tasks with
>> higher priority.
>
> Nobody said that you have to write a rtl8712-mac80211.
> But right now there is a better alternative, and it should be used.

Go ahead and submit it and remove r8712u. I would be more than happy to be able 
to just bitch about bugs the way other people do! :)

Larry


