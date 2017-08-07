Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38342 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbdHGN2O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 09:28:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Subject: Re: [PATCH 04/19] iwlwifi: mvm: add debugfs to force CT-kill
References: <20170805194331.17426-1-luca@coelho.fi>
        <20170805194331.17426-5-luca@coelho.fi>
        <87zibbjzel.fsf@kamboji.qca.qualcomm.com>
        <1502112333.15969.122.camel@coelho.fi>
Date: Mon, 07 Aug 2017 16:28:09 +0300
In-Reply-To: <1502112333.15969.122.camel@coelho.fi> (Luca Coelho's message of
        "Mon, 07 Aug 2017 16:25:33 +0300")
Message-ID: <87r2wnjymu.fsf@kamboji.qca.qualcomm.com> (sfid-20170807_152817_622604_C2BEED51)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Mon, 2017-08-07 at 16:11 +0300, Kalle Valo wrote:
>> Luca Coelho <luca@coelho.fi> writes:
>> 
>> > From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
>> > 
>> > In order to test the enter/exit CT-kill flow.
>> > 
>> > Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
>> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>> 
>> The commit log doesn't explain what's CT-kill and how/where it could be
>> used. For example, I have no clue what this could be about.
>
> You're right, sorry for that.  I'll update the commit log and submit v2.
>
> Basically CT-kill is a thermal "RF-kill".  Whenever the NIC gets too
> hot, we shut it down to prevent further damage.  This is nothing new. 
> What this patch is adding is a fake way to simulate the NIC getting too
> hot by kicking off a debugfs entry, in the same way the FW would kick it
> off by sending a notification to the driver.
>
> This is mostly for R&D, but it's very useful for us and I we need it for
> our internal tests.  Not that useful for non-developers but I didn't
> want to carry this in internal driver to avoid unnecessary conflicts
> when syncing it with upstream.

Thanks, makes sense now.

-- 
Kalle Valo
