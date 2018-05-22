Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40888 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbeEVOG0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 10:06:26 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Dreyfuss\, Haim" <haim.dreyfuss@intel.com>
Cc: Eric Biggers <ebiggers3@gmail.com>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho\, Luciano" <luciano.coelho@intel.com>
Subject: Re: [4.17 iwlwifi regression] NULL pointer dereference in reg_query_regdb_wmm()
References: <20180519183345.GA701@sol.localdomain>
        <409B2791E285FD41B488E034D9B4719F27E99C58@HASMSX106.ger.corp.intel.com>
        <87muwtezwy.fsf@kamboji.qca.qualcomm.com>
        <409B2791E285FD41B488E034D9B4719F27E99E2B@HASMSX106.ger.corp.intel.com>
Date: Tue, 22 May 2018 17:06:19 +0300
In-Reply-To: <409B2791E285FD41B488E034D9B4719F27E99E2B@HASMSX106.ger.corp.intel.com>
        (Haim Dreyfuss's message of "Mon, 21 May 2018 16:56:41 +0000")
Message-ID: <87a7srg4ys.fsf@kamboji.qca.qualcomm.com> (sfid-20180522_160629_372395_A59D7624)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Dreyfuss, Haim" <haim.dreyfuss@intel.com> writes:

> Yeah, MCC stands for Mobile Country Code.
> You can find it in the dmesg 
> "iwl_mvm_get_regdomain Getting regdomain data for ZZ from FW "
> " iwl_mvm_update_mcc send MCC update to FW with 'ZZ' src = 16"

Please do not top post:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#do_not_top_post_and_edit_your_quotes

-- 
Kalle Valo
