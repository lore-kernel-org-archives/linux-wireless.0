Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:53440 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdITIjl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 04:39:41 -0400
Received: by mail-qk0-f174.google.com with SMTP id t184so1993295qke.10
        for <linux-wireless@vger.kernel.org>; Wed, 20 Sep 2017 01:39:41 -0700 (PDT)
Subject: Re: [PATCH] mwifiex: add device specific ioctl handler
To: Xinming Hu <huxinming820@gmail.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>
References: <1505889853-20493-1-git-send-email-huxinming820@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <59C22949.9030304@broadcom.com> (sfid-20170920_103946_805822_11AAC506)
Date: Wed, 20 Sep 2017 10:39:37 +0200
MIME-Version: 1.0
In-Reply-To: <1505889853-20493-1-git-send-email-huxinming820@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/20/2017 8:44 AM, Xinming Hu wrote:
> From: Xinming Hu <huxm@marvell.com>
>
> Add net_dev ndo_do_ioctl handler, which could be used for
> downloading host command by utility in manufactory test

Not sure if we want ioctls in upstream wireless drivers. You could look 
at nl80211 vendor commands, but that is also under scrutiny if common 
wifi functionality is provided by it. I am pretty sure Kalle has his 
ideas about this :-)

Regards,
Arend
