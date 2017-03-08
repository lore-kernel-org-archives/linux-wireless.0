Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57764 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751657AbdCHP3r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 10:29:47 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Karthik D A <karthida@marvell.com>
Subject: Re: [PATCH 1/3] mwifiex: add qualifier to firmware structures
References: <1488980829-6075-1-git-send-email-gbhat@marvell.com>
        <1488980829-6075-2-git-send-email-gbhat@marvell.com>
Date: Wed, 08 Mar 2017 16:48:00 +0200
In-Reply-To: <1488980829-6075-2-git-send-email-gbhat@marvell.com> (Ganapathi
        Bhat's message of "Wed, 8 Mar 2017 19:17:07 +0530")
Message-ID: <874lz37rkv.fsf@purkki.adurom.net> (sfid-20170308_163026_782026_69A12F64)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> writes:

> From: Karthik D A <karthida@marvell.com>
>
> Adding qualifier "__packed" indicates that no padding should be
> performed on the qualified object for alignment.
> This patch adds qualifier __packed to the required firmware
> structures in mwifiex driver.
>
> Signed-off-by: Karthik D A <karthida@marvell.com>

I just want to confirm "Karthik D A" is really the full legal name,
which should be in both From and Signed-off-by lines. No nicknames nor
just the first name or anything like that.

Also this should contain S-o-b from Ganapathi. Please carefully read
Documentation/process/submitting-patches.rst.

-- 
Kalle Valo
