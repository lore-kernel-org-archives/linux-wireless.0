Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45668 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387719AbeHAKBq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 06:01:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/16] iwlwifi: updates intended for v4.19 2018-07-27
References: <20180727124838.25910-1-luca@coelho.fi>
        <87wota8qr2.fsf@kamboji.qca.qualcomm.com>
        <a3d8f0dcd43467c412ffcb72e2b4361f210a1cc6.camel@intel.com>
Date: Wed, 01 Aug 2018 11:17:12 +0300
In-Reply-To: <a3d8f0dcd43467c412ffcb72e2b4361f210a1cc6.camel@intel.com>
        (Luciano Coelho's message of "Wed, 01 Aug 2018 11:11:25 +0300")
Message-ID: <87muu68prr.fsf@kamboji.qca.qualcomm.com> (sfid-20180801_102123_500018_00CEBF11)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luciano.coelho@intel.com> writes:

> On Wed, 2018-08-01 at 10:56 +0300, Kalle Valo wrote:
>> Luca Coelho <luca@coelho.fi> writes:
>> 
>> > From: Luca Coelho <luciano.coelho@intel.com>
>> > 
>> > Hi,
>> > 
>> > Here's one more set of patches intended for v4.19.  It contains
>> > some
>> > bugfixes, cleanups and more work on supporting the 22560 family of
>> > devices.
>> > 
>> > The changes are:
>> > 
>> > * New PCI IDs for 22000 and 22560;
>> > * Some fixes and an improvement in debug dumps and recording;
>> > * Remove some old dead code;
>> > * Fix compilation when only IPv6 is not enabled;
>> 
>> -EPARSE, "when only ... not"?
>
> That's perfectly fine grammar. :) "If only IPv6 is not enabled,
> compilation fails.  Fix that."
>
> Though not exactly what I meant, I meant "when IPv6 is not enabled".

Yeah, that's more understandable :)

Also I got last three patches two times, but maybe that was a problem
with email servers or something.

-- 
Kalle Valo
