Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51904 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752620AbdA3JHt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 04:07:49 -0500
Date: Mon, 30 Jan 2017 10:06:55 +0100
From: Greg KH <greg@kroah.com>
To: c_traja@qti.qualcomm.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        stable@vger.kernel.org, tamizhchelvam@codeaurora.org
Subject: Re: [PATCHv2] ath10k: fix boot failure in UTF mode/testmode
Message-ID: <20170130090655.GB29062@kroah.com> (sfid-20170130_113018_125867_CEF1590A)
References: <1485765958-26802-1-git-send-email-c_traja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1485765958-26802-1-git-send-email-c_traja@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 30, 2017 at 02:15:58PM +0530, c_traja@qti.qualcomm.com wrote:
> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
> 
> Rx filter reset and the dynamic tx switch mode (EXT_RESOURCE_CFG)
> configuration are causing the following errors when UTF firmware
> is loaded to the target.
> 
> Error message 1:
> [ 598.015629] ath10k_pci 0001:01:00.0: failed to ping firmware: -110
> [ 598.020828] ath10k_pci 0001:01:00.0: failed to reset rx filter: -110
> [ 598.141556] ath10k_pci 0001:01:00.0: failed to start core (testmode): -110
> 
> Error message 2:
> [ 668.615839] ath10k_ahb a000000.wifi: failed to send ext resource cfg command : -95
> [ 668.618902] ath10k_ahb a000000.wifi: failed to start core (testmode): -95
> 
> Avoiding these configurations while bringing the target in
> testmode is solving the problem.
> 
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
> ---
> v2:
>    *Added stable@vger.kernel.org in cc list


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
