Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59652 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751020AbdFGGiY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Jun 2017 02:38:24 -0400
Message-ID: <1496817497.9478.112.camel@coelho.fi> (sfid-20170607_083859_796576_8DB1AC5A)
From: Luca Coelho <luca@coelho.fi>
To: Seraphime Kirkovski <kirkseraph@gmail.com>, johannes.berg@intel.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "open list:INTEL WIRELESS WIFI LINK (iwlwifi)"
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 07 Jun 2017 09:38:17 +0300
In-Reply-To: <20170606232031.28893-1-kirkseraph@gmail.com>
References: <20170606232031.28893-1-kirkseraph@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] net: wireless: intel: iwlwifi: dvm: remove unused
 defines
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-07 at 01:20 +0200, Seraphime Kirkovski wrote:
> Those constants have been unused for quite some time now.
> 
> Signed-off-by: Seraphime Kirkovski <kirkseraph@gmail.com>
> ---
>  I've compile-tested it.

Thanks.  I've applied it to our internal tree and it will reach the
mainline at some point.

--
Cheers,
Luca.
