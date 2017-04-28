Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49770 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164476AbdD1JZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 05:25:40 -0400
Message-ID: <1493371536.2431.7.camel@sipsolutions.net> (sfid-20170428_112545_362985_944C8CD7)
Subject: Re: [PATCH 4/9] cfg80211: unify cfg80211_roamed() and
 cfg80211_roamed_bss()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Apr 2017 11:25:36 +0200
In-Reply-To: <20170426075854.13546-5-luca@coelho.fi>
References: <20170426075854.13546-1-luca@coelho.fi>
         <20170426075854.13546-5-luca@coelho.fi>
Content-Type: text/plain
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied, with the cast removed as Arend spotted.

johannes
