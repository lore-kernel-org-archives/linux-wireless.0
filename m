Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59342 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbeCJIaA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 03:30:00 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arjav Parikh <parikharjav24@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Dependency required for wil6210 kernel module
References: <CADoF8+AU991ut3889d0QsxVfKsQ_YXAYQBhQPzLWmxNE1Kn_WA@mail.gmail.com>
Date: Sat, 10 Mar 2018 10:29:56 +0200
In-Reply-To: <CADoF8+AU991ut3889d0QsxVfKsQ_YXAYQBhQPzLWmxNE1Kn_WA@mail.gmail.com>
        (Arjav Parikh's message of "Sat, 10 Mar 2018 12:52:07 +0530")
Message-ID: <87bmfw49kq.fsf@purkki.adurom.net> (sfid-20180310_093014_426121_64C63222)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arjav Parikh <parikharjav24@gmail.com> writes:

> Currently I am working to minimize the filesystem for one of my
> project. In my project I only want to add support for USB & Wireless
> (wil6210). To minimize the filesystem I disabled the unwanted things
> like Iptables, VLAN, VPN, Ethernet support etc from .config and
> brought my image size from 22 MB to 8.9 MB.
>
> Now when I did the ifconfig wlan0 up I get below error:
> wil6210 0000:01:00.0 wlan0: wil_open: Failed to register with NSS
>
> In Ideal case when I enter the above command I should get below logs:
> wil6210 0000:01:00.0 wlan0: wil_open: Registered with NSS
>
> I checked the dependency for wil6210.ko module and they are cfg80211 &
> compat and they both are enabled.
>
> Can any one tell me which libraries/modules I have mistakenly disabled
> which is causing this error.

What kernel are you using? The NSS error messages imply that it's
something else than upstream (kernel.org) kernel.

-- 
Kalle Valo
