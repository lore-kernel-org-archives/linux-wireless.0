Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:64175 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753983AbdLDM5Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 07:57:24 -0500
Message-ID: <1512392240.4827.126.camel@intel.com> (sfid-20171204_135733_295942_AC17A95D)
Subject: Re: [PATCH 12/15] iwlwifi: mvm: enable RX offloading with TKIP and
 WEP
From: Luciano Coelho <luciano.coelho@intel.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Date: Mon, 04 Dec 2017 14:57:20 +0200
In-Reply-To: <20171202162858.4167-13-luca@coelho.fi>
References: <20171202162858.4167-1-luca@coelho.fi>
         <20171202162858.4167-13-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-12-02 at 18:28 +0200, Luca Coelho wrote:
> From: David Spinadel <david.spinadel@intel.com>
> 
> Set the flag that indicates that ICV was stripped on if
> this option was enabled in the HW.
> 
> Signed-off-by: David Spinadel <david.spinadel@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---

I'll move this to my fixes series, because it's needed for the 9000
series, which is currently broken upstream... :(

--
Cheers,
Luca.
