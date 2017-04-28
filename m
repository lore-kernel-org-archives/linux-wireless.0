Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49784 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1165016AbdD1J0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 05:26:19 -0400
Message-ID: <1493371577.2431.8.camel@sipsolutions.net> (sfid-20170428_112623_591147_AAAA8F98)
Subject: Re: [PATCH 2/9] mac80211: Add support for BSS max idle period
 element
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Apr 2017 11:26:17 +0200
In-Reply-To: <20170426075854.13546-3-luca@coelho.fi>
References: <20170426075854.13546-1-luca@coelho.fi>
         <20170426075854.13546-3-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-04-26 at 10:58 +0300, Luca Coelho wrote:
> From: Avraham Stern <avraham.stern@intel.com>
> 
> Parse the BSS max idle period element and set the BSS configuration
> accordingly so the driver can use this information to configure the
> max idle period and to use protected management frames for keep alive
> when required.

Also applied.

johannes
