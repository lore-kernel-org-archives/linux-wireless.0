Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tactel.se ([82.99.24.195]:56383 "EHLO mail.tactel.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab1LOJii (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 04:38:38 -0500
Message-ID: <4EE9BA59.4070607@tactel.se> (sfid-20111215_103843_396388_A77076FD)
Date: Thu, 15 Dec 2011 10:14:01 +0100
From: Pontus Fuchs <pontus.fuchs@tactel.se>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Set wlvif->ps_compl to NULL in before return
References: <1323869543-2846-1-git-send-email-pontus.fuchs@gmail.com> <1323939307.2800.183.camel@cumari>
In-Reply-To: <1323939307.2800.183.camel@cumari>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-12-15 09:55, Luciano Coelho wrote:
> On Wed, 2011-12-14 at 14:32 +0100, Pontus Fuchs wrote:
>> wl1271_configure_suspend_sta leaves a stale stack declared
>> completion in wlvif->ps_compl. Set it to NULL before returning.
>>
>> Signed-off-by: Pontus Fuchs<pontus.fuchs@gmail.com>
>> ---
>
> Applied with a small fix.  wl->ps_compl was used, which doesn't exist
> anymore.  I changed it to wlvif->ps_compl before applying.

Thanks :) I Messed up when moving the code to your latest tree.

-ETOMANYTREES or something

Cheers,

Pontus
