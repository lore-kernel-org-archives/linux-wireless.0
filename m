Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49346 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbeHAJkb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 05:40:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 00/16] iwlwifi: updates intended for v4.19 2018-07-27
References: <20180727124838.25910-1-luca@coelho.fi>
Date: Wed, 01 Aug 2018 10:56:01 +0300
In-Reply-To: <20180727124838.25910-1-luca@coelho.fi> (Luca Coelho's message of
        "Fri, 27 Jul 2018 15:48:22 +0300")
Message-ID: <87wota8qr2.fsf@kamboji.qca.qualcomm.com> (sfid-20180801_102121_124766_8F05EF74)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Luca Coelho <luciano.coelho@intel.com>
>
> Hi,
>
> Here's one more set of patches intended for v4.19.  It contains some
> bugfixes, cleanups and more work on supporting the 22560 family of
> devices.
>
> The changes are:
>
> * New PCI IDs for 22000 and 22560;
> * Some fixes and an improvement in debug dumps and recording;
> * Remove some old dead code;
> * Fix compilation when only IPv6 is not enabled;

-EPARSE, "when only ... not"?

-- 
Kalle Valo
