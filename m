Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:36610 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751504AbdBOKue (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 05:50:34 -0500
Received: by mail-pg0-f45.google.com with SMTP id v184so36156089pgv.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2017 02:50:34 -0800 (PST)
Subject: Re: wireless driver crashing frequently
To: ravin goyal <ravirocks1021@gmail.com>
References: <CANU0Mn00ju_SZ3L+ipdnZ5R-Y1m+T=MhjHmBjMpKN_i8NPWsrg@mail.gmail.com>
 <dea21c18-30a4-f236-6f8b-1bf8d4391e0b@broadcom.com>
 <CANU0Mn2Fp=3tYb70qD7J_duA0f1wbRNr_Q3e5iv3pBTHtWM4zg@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <586c8cf6-75fb-64cb-adaa-4c5de7ec7008@broadcom.com> (sfid-20170215_115037_987630_C2778B71)
Date: Wed, 15 Feb 2017 11:50:29 +0100
MIME-Version: 1.0
In-Reply-To: <CANU0Mn2Fp=3tYb70qD7J_duA0f1wbRNr_Q3e5iv3pBTHtWM4zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 15-2-2017 11:38, ravin goyal wrote:
> that is what I have found on my banana pi board running raspbian lite
> 3.4.112-sun8i.
> removing bcmdhd results in removing my wlan0 interface from the
> list(iwconfig/ifconfig/ip).

Ok. If it is raspbian that choose to include bcmdhd in their distro I
would suggest to file the bug there [1].

Regards,
Arend

[1] https://www.raspbian.org/RaspbianBugs
