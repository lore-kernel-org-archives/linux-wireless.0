Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:31244 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751279AbdJLSQl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 14:16:41 -0400
Message-ID: <1507832196.5497.1.camel@intel.com> (sfid-20171012_201710_302599_F6683F90)
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with
 the wireless-drivers tree
From: Luciano Coelho <luciano.coelho@intel.com>
To: Mark Brown <broonie@kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 12 Oct 2017 21:16:36 +0300
In-Reply-To: <20171012172512.tlsdjhppfz2hu4vr@sirena.co.uk>
References: <20171012172512.tlsdjhppfz2hu4vr@sirena.co.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-10-12 at 18:25 +0100, Mark Brown wrote:
> Hi all,

Hi Mark,


> Today's linux-next merge of the wireless-drivers-next tree got a
> conflict in:
> 
>   drivers/net/wireless/intel/iwlwifi/iwl-config.h
> 
> between commit:
> 
>    dd05f9aab4426f ("iwlwifi: pcie: dynamic Tx command queue size")
> 
> from the wireless-drivers tree and commit:
> 
>    44fd09dad5d2b7 ("iwlwifi: nvm: set the correct offsets to 3168
> series")
> 
> from the wireless-drivers-next tree.

This is weird... The previous conflict was the exact opposite of this. 
44fd09 came in from wireless-drivers and dd05f9 came from wireless-
drivers-next.  I don't understand why it is saying the opposite here...

--
Cheers,
Luca.
