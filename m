Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39456 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754474AbcK1HWA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 02:22:00 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de
Subject: Re: [PATCH 1/5] rsi: Device configuration bootup parameters updated
References: <1479125750-2598-1-git-send-email-prameela.j04cs@gmail.com>
        <e2acef96-6d2f-e5ad-aa74-5916ebb7e0bf@redpinesignals.com>
Date: Mon, 28 Nov 2016 09:21:52 +0200
In-Reply-To: <e2acef96-6d2f-e5ad-aa74-5916ebb7e0bf@redpinesignals.com>
        (Prameela Rani Garnepudi's message of "Mon, 28 Nov 2016 10:13:43
        +0530")
Message-ID: <87h96s83xr.fsf@kamboji.qca.qualcomm.com> (sfid-20161128_082236_341492_A8DABC61)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com> writes:

> On 11/14/2016 05:45 PM, Prameela Rani Garnepudi wrote: 
>> Switch clock info values are changed in the firmware for both 20MHZ 
>> and 40MHZ modes. Hence these values which are configured through boot 
>> parameters request frame are updated. Also three other power save 
>> related parameters are added to boot up parameters. 
>> 
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com> 

(Removed over hundred lines of unnecessary quotes, please edit your
quotes.)

> Can you please tell me, what modifications need to be done for this  
> patch. I already modified the code as per your previous suggestions. 

Like always, please check the patchwork before sending any emails. The
patch in question is here:

https://patchwork.kernel.org/patch/9427401/

It's in state "Changes Requested" which means that one of patches in the
patchset should have some comments. After looking at the other patches I
see my comment in patch 2:

https://patchwork.kernel.org/patch/9427419/

        "Based on Documentation/kernel-documentation.rst this doesn't
         look to be valid kernel-doc format. But AFAICS you got the
         format correct in patch 3.

         Also this function uses negative error codes (as preferred),
         it's not just -1 on failure. You should fix that in the comment
         (similar problems also elsewhere in this patchset)."

-- 
Kalle Valo
