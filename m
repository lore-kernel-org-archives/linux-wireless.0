Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39819 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934201AbeGFS5v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 14:57:51 -0400
Message-ID: <1e031d2cffff65e7ba8390cfa09dac0743371548.camel@intel.com> (sfid-20180706_205754_823266_84FB6C1B)
Subject: Re: [PATCH] WHENCE: Fix typo Version v3
From: Luciano Coelho <luciano.coelho@intel.com>
To: Sedat Dilek <sedat.dilek@credativ.de>,
        linux-wireless@vger.kernel.org
In-Reply-To: <20180517152011.10322-1-sedat.dilek@credativ.de>
References: <20180517152011.10322-1-sedat.dilek@credativ.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Jul 2018 21:57:39 +0300
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, 2018-05-17 at 17:20 +0200, Sedat Dilek wrote:
> I have seen that in the WHENCE file there is "Version" with and
> without ":", mostly iwlwifi ucodes.
> 
> As an example:
> 
>  File: iwlwifi-8265-36.ucode
> -Version 36.e91976c0.0
> +Version: 36.e91976c0.0
> 
> The usual case is "Version:".
> 
> This patch is against iwlwifi.git#linux-firmware.
> 
> Signed-off-by: Sedat Dilek <sedat.dilek@credativ.de>
> ---

Looks fine, but I guess you should base this on linux-firmware.git and
send it to linux-firmware@vger.kernel.org.

--
Cheers,
Luca.
