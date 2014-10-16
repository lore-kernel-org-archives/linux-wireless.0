Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:59031 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaJPUmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 16:42:44 -0400
Received: by mail-oi0-f46.google.com with SMTP id h136so3299037oig.5
        for <linux-wireless@vger.kernel.org>; Thu, 16 Oct 2014 13:42:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
Date: Thu, 16 Oct 2014 23:42:43 +0300
Message-ID: <CANUX_P3Xqb3sojJ3FDrkLDni=MTvdOzo1XbSLxrhuwmz6yZ-Ag@mail.gmail.com> (sfid-20141016_224247_453544_551100A6)
Subject: Re: iwlwifi: Reason 7 periodic disconnect
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?Q?Lauren=C8=9Biu_Nicola?= <lnicola@dend.ro>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 16, 2014 at 3:48 PM, Laurențiu Nicola <lnicola@dend.ro> wrote:
> Hello,
>
> I'm using iwlwifi for a Centrino Ultimate-N 6300 on 3.14.4 and 3.17.1.
> Connect to my wireless network works, but I get disconnected every 60
> seconds or so. The dmesg output looks like
> https://bpaste.net/show/1623a8ae5dc6 .
>
> I had the same issue on the three latest firmware versions:
> iwlwifi-6000-ucode-9.176.4.1
> iwlwifi-6000-ucode-9.193.4.1
> iwlwifi-6000-ucode-9.221.4.1
>
> The dmesg log actually shows the driver loading the different versions
> above.
>
> It's the first time I try to use wireless on Linux, so I might have made
> a dumb mistake.
>

I'd try to use a different network manager.
This is the the place to get support for this though.
