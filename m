Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:41996 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753077AbeEUQ6b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 12:58:31 -0400
From: "Dreyfuss, Haim" <haim.dreyfuss@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: Eric Biggers <ebiggers3@gmail.com>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [4.17 iwlwifi regression] NULL pointer dereference in
 reg_query_regdb_wmm()
Date: Mon, 21 May 2018 16:56:41 +0000
Message-ID: <409B2791E285FD41B488E034D9B4719F27E99E2B@HASMSX106.ger.corp.intel.com> (sfid-20180521_185842_793822_E6A81DF9)
References: <20180519183345.GA701@sol.localdomain>
        <409B2791E285FD41B488E034D9B4719F27E99C58@HASMSX106.ger.corp.intel.com>
 <87muwtezwy.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87muwtezwy.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeah, MCC stands for Mobile Country Code.
You can find it in the dmesg 
"iwl_mvm_get_regdomain Getting regdomain data for ZZ from FW "
" iwl_mvm_update_mcc send MCC update to FW with 'ZZ' src = 16"

Cheers
Dreyfuss

-----Original Message-----
From: Kalle Valo [mailto:kvalo@codeaurora.org] 
Sent: Monday, May 21, 2018 7:28 PM
To: Dreyfuss, Haim <haim.dreyfuss@intel.com>
Cc: Eric Biggers <ebiggers3@gmail.com>; linuxwifi <linuxwifi@intel.com>; linux-wireless@vger.kernel.org; Coelho, Luciano <luciano.coelho@intel.com>
Subject: Re: [4.17 iwlwifi regression] NULL pointer dereference in reg_query_regdb_wmm()

"Dreyfuss, Haim" <haim.dreyfuss@intel.com> writes:

> Can you provide the following information?
> 1. The *boot* you mentioned is from clean shutdown or from Sx state?
> 2. Do you know which MCC the driver is trying to update?

You could also give some hints how to find the MCC and even tell what it means. Is it Mobile Country Code or what?

--
Kalle Valo
