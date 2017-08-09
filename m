Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53512 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752464AbdHIHgt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 03:36:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH v2 4/19] iwlwifi: mvm: add debugfs to force CT-kill
References: <87r2wnjymu.fsf@kamboji.qca.qualcomm.com>
        <20170809064341.13523-1-luca@coelho.fi>
Date: Wed, 09 Aug 2017 10:36:44 +0300
In-Reply-To: <20170809064341.13523-1-luca@coelho.fi> (Luca Coelho's message of
        "Wed, 9 Aug 2017 09:43:41 +0300")
Message-ID: <87a839i44z.fsf@kamboji.qca.qualcomm.com> (sfid-20170809_093652_521984_3F69E045)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
>
> CT-kill is a thermal-based "RF-kill", which disables the NIC
> completely if the temperature gets too high, in order to avoid damage.
>
> Add a debugfs entry to simulate high temperatures, in order to test
> CT-kill flows in the driver without having to physically heat the
> device up.
>
> Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

This is perfect, kiitti!

-- 
Kalle Valo
