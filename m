Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35590 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751554AbdF1LuD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 07:50:03 -0400
Message-ID: <1498650587.22048.110.camel@coelho.fi> (sfid-20170628_135024_871039_73FE72E8)
From: Luca Coelho <luca@coelho.fi>
To: Bhumika Goyal <bhumirks@gmail.com>, julia.lawall@lip6.fr,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Jun 2017 14:49:47 +0300
In-Reply-To: <1498034442-17664-1-git-send-email-bhumirks@gmail.com>
References: <1498034442-17664-1-git-send-email-bhumirks@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: mvm: add const to thermal_cooling_device_ops
 structure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-21 at 14:10 +0530, Bhumika Goyal wrote:
> Declare thermal_cooling_device_ops structure as const as it is only passed
> as an argument to the function thermal_cooling_device_register and this
> argument is of type const. So, declare the structure as const.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
> ---

Thanks, we're reviewing this internally.  It looks fine, but I need to
assess whether this will have any impacts in our backports project
before we can apply it.

--
Cheers,
Luca.
