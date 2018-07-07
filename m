Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:51396 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750861AbeGGHlb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jul 2018 03:41:31 -0400
Message-ID: <ebe5bbb03ca9c39e468d7f40d67d58733062a1f9.camel@intel.com> (sfid-20180707_094153_610734_7959B439)
Subject: Re: [PATCH 09/12] iwlwifi: Remove local iwl_bcast_addr and use
 ether_broadcast_addr
From: Luciano Coelho <luciano.coelho@intel.com>
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Sat, 07 Jul 2018 10:40:35 +0300
In-Reply-To: <af831d8873ffcc36014244f76d21cd6aaf5aca9c.1522479608.git.joe@perches.com>
References: <cover.1522479607.git.joe@perches.com>
         <af831d8873ffcc36014244f76d21cd6aaf5aca9c.1522479608.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-03-31 at 00:05 -0700, Joe Perches wrote:
> Use the new global to save a little bit of object code.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

I took this one to our internal tree and it will be applied as part of
our normal upstreaming process.

Thanks!

--
Luca.
