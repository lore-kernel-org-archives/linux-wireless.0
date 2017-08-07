Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53472 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbdHGNLg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 09:11:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 04/19] iwlwifi: mvm: add debugfs to force CT-kill
References: <20170805194331.17426-1-luca@coelho.fi>
        <20170805194331.17426-5-luca@coelho.fi>
Date: Mon, 07 Aug 2017 16:11:30 +0300
In-Reply-To: <20170805194331.17426-5-luca@coelho.fi> (Luca Coelho's message of
        "Sat, 5 Aug 2017 22:43:16 +0300")
Message-ID: <87zibbjzel.fsf@kamboji.qca.qualcomm.com> (sfid-20170807_151140_008766_4176817C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
>
> In order to test the enter/exit CT-kill flow.
>
> Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

The commit log doesn't explain what's CT-kill and how/where it could be
used. For example, I have no clue what this could be about.

-- 
Kalle Valo
