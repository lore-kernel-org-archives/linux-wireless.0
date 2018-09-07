Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2414 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728415AbeIGP03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 11:26:29 -0400
Message-ID: <823634a7ab18ad1f536cf1771fbfd27b1c711917.camel@intel.com> (sfid-20180907_124619_033132_6B9E6BCB)
Subject: Re: [PATCH 09/12] iwlwifi: Remove local iwl_bcast_addr and use
 ether_broadcast_addr
From: Luciano Coelho <luciano.coelho@intel.com>
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 07 Sep 2018 13:46:03 +0300
In-Reply-To: <ebe5bbb03ca9c39e468d7f40d67d58733062a1f9.camel@intel.com>
References: <cover.1522479607.git.joe@perches.com>
         <af831d8873ffcc36014244f76d21cd6aaf5aca9c.1522479608.git.joe@perches.com>
         <ebe5bbb03ca9c39e468d7f40d67d58733062a1f9.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-07-07 at 10:40 +0300, Luciano Coelho wrote:
> On Sat, 2018-03-31 at 00:05 -0700, Joe Perches wrote:
> > Use the new global to save a little bit of object code.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> 
> I took this one to our internal tree and it will be applied as part
> of our normal upstreaming process.

It seems that the patch to etherdevice.h never got applied upstream, so
I'm actually dropping this patch.

Please resend if it becomes relevant again.

--
Cheers,
Luca.
