Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51270 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751141AbeFHPAc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Jun 2018 11:00:32 -0400
Message-ID: <fd9df092d8228be5d605f15b38731fb307b76fab.camel@intel.com> (sfid-20180608_170036_154774_2FDAA51A)
Subject: Re: [PATCH 3/3] mac80211: add support for HE
From: Luciano Coelho <luciano.coelho@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
        Liad Kaufman <liad.kaufman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Ido Yariv <idox.yariv@intel.com>
Date: Fri, 08 Jun 2018 18:00:28 +0300
In-Reply-To: <20180608071203.20708-4-luca@coelho.fi>
References: <20180608071203.20708-1-luca@coelho.fi>
         <20180608071203.20708-4-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-06-08 at 10:12 +0300, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> Add support for HE in mac80211 conforming with P802.11ax_D1.4.
> 
> Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> Signed-off-by: Ido Yariv <idox.yariv@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---

Please hold back with this one.  Ido noticed that there is an important
fix missing here.  I'll send v2.

--
Cheers,
Luca.
