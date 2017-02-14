Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:36182 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbdBNTWj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 14:22:39 -0500
Received: by mail-it0-f41.google.com with SMTP id c7so46515704itd.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2017 11:22:39 -0800 (PST)
From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: R92SU - Realtek RTL8192SU/RTL8191SU/RTL8188SU USB Wireless
 Network Adapters
To: poma <pomidorabelisima@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>
References: <3255266e-5116-8e5e-bf22-db1dab02c769@gmail.com>
Cc: "David A. De Graaf" <dad@datix.us>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <2b236381-db7a-ab3f-73f1-b918a1a51c17@gmail.com> (sfid-20170214_202243_143106_FA38EDC8)
Date: Tue, 14 Feb 2017 14:22:36 -0500
MIME-Version: 1.0
In-Reply-To: <3255266e-5116-8e5e-bf22-db1dab02c769@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2017 01:28 PM, poma wrote:
> Hello fellows!
>
> https://github.com/chunkeey/rtl8192su/tree/master/r92su
> r92su seems like the simplest and most effective replacement for r8712u.
>
> https://bugzilla.redhat.com/show_bug.cgi?id=1421383
> Christian, I can not add you there, so I'm asking here,
> is there any particular reason why r92su is not already accepted in mainline?
>
> Is there an intention to "Realtek RTL8192SU/RTL8191SU/RTL8188SU USB Wireless Network Adapters" join "RTL8XXXu USB mac80211 Wireless LAN Driver" support?

I see no reason why SU support cannot be added to rtl8xxxu, however 
given the age of these chips and the amount of time I have to work on 
the code, it is pretty far from the top of my priority list.

If someone else is going to work on it, I am happy to work with that 
person to integrate the code.

Jes
