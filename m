Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45554 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753741AbdKNKwE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 05:52:04 -0500
Message-ID: <1510656721.4011.87.camel@coelho.fi> (sfid-20171114_115222_984041_3ADD8789)
From: Luca Coelho <luca@coelho.fi>
To: Thomas Backlund <tmb@mageia.org>, linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org
Date: Tue, 14 Nov 2017 12:52:01 +0200
In-Reply-To: <20171114103751.7761-1-tmb@mageia.org>
References: <20171114103751.7761-1-tmb@mageia.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: fix firmware names for 9xxx and a0 series hw
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-11-14 at 12:37 +0200, Thomas Backlund wrote:
> iwlwifi 9xxx and a0 series hw contains an extra dash in firmware file
> name
> as seeen in modinfo output for kernel 4.14:
> 
> firmware:       iwlwifi-9260-th-b0-jf-b0--34.ucode
> firmware:       iwlwifi-9260-th-a0-jf-a0--34.ucode
> firmware:       iwlwifi-9000-pu-a0-jf-b0--34.ucode
> firmware:       iwlwifi-9000-pu-a0-jf-a0--34.ucode
> firmware:       iwlwifi-QuQnj-a0-hr-a0--34.ucode
> firmware:       iwlwifi-QuQnj-a0-jf-b0--34.ucode
> firmware:       iwlwifi-QuQnj-f0-hr-a0--34.ucode
> firmware:       iwlwifi-Qu-a0-jf-b0--34.ucode
> firmware:       iwlwifi-Qu-a0-hr-a0--34.ucode
> 
> Fix that by dropping the extra adding of '"-"'.
> 
> Signed-off-by: Thomas Backlund <tmb@mageia.org>
> cc: Luca Coelho <luciano.coelho@intel.com>
> cc: stable@vger.kernel.org
> 
> ---

Looks good, thanks!

Though I'm not sure this is worth sending to stable... Why do you think
it's needed?

Anyway, I'm applying it in our internal tree and it will reach the
mainline following our normal upstreaming process.

--
Cheers,
Luca.
