Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56608 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdLEF07 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 00:26:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 05 Dec 2017 10:56:58 +0530
From: akolli@codeaurora.org
To: mbizon@freebox.fr
Cc: akolli@qti.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
In-Reply-To: <1512397413.14552.67.camel@sakura.staff.proxad.net>
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com>
 <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com>
 <1512125137.38490.70.camel@sakura.staff.proxad.net>
 <7792e2fb2c546d8745c65e48945f2535@codeaurora.org>
 <1512140710.38490.81.camel@sakura.staff.proxad.net>
 <45d5ada8ea658e49af85582b4f3f71f7@codeaurora.org>
 <1512397413.14552.67.camel@sakura.staff.proxad.net>
Message-ID: <642ec05b29239335ba748f25e248634b@codeaurora.org> (sfid-20171205_062703_945863_9031818A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-12-04 19:53, Maxime Bizon wrote:
> On Mon, 2017-12-04 at 18:54 +0530, akolli@codeaurora.org wrote:
> 
>> Hope 10.2.4-1.0-00029 Firmware binary works for you.
> 
> it does
> 
>> I will check this warning.
> 
> fixed by applying patch:
>  "[PATCH] ath10k: fix recent bandwidth conversion bug"
> 
> as suggested by Christian Lamparter
> 
> only remaining oddity is the CONFIG_MAC80211_DEBUGFS dependency

I will send a patch to remove this dependency.

Thanks,
Anil.
