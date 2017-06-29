Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36190 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752407AbdF2RIM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 13:08:12 -0400
Message-ID: <1498756084.22048.143.camel@coelho.fi> (sfid-20170629_190854_257142_7709F16A)
From: Luca Coelho <luca@coelho.fi>
To: Bhumika Goyal <bhumirks@gmail.com>, julia.lawall@lip6.fr,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Jun 2017 20:08:04 +0300
In-Reply-To: <1498650587.22048.110.camel@coelho.fi>
References: <1498034442-17664-1-git-send-email-bhumirks@gmail.com>
         <1498650587.22048.110.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: mvm: add const to thermal_cooling_device_ops
 structure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-28 at 14:49 +0300, Luca Coelho wrote:
> On Wed, 2017-06-21 at 14:10 +0530, Bhumika Goyal wrote:
> > Declare thermal_cooling_device_ops structure as const as it is only passed
> > as an argument to the function thermal_cooling_device_register and this
> > argument is of type const. So, declare the structure as const.
> > 
> > Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
> > ---
> 
> Thanks, we're reviewing this internally.  It looks fine, but I need to
> assess whether this will have any impacts in our backports project
> before we can apply it.

This has been applied in our internal tree and will eventually land in
the mainline.

Thanks!

--
Cheers,
Luca.
