Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42538 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752899AbdBHJvB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 04:51:01 -0500
Message-ID: <1486544801.4603.13.camel@sipsolutions.net> (sfid-20170208_105212_108278_4301587A)
Subject: Re: [PATCH] nl80211: add HT/VHT capabilities to AP parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 08 Feb 2017 10:06:41 +0100
In-Reply-To: <20170207204044.1950-1-luca@coelho.fi>
References: <20170207204044.1950-1-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-07 at 22:40 +0200, Luca Coelho wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> For the benefit of drivers that rebuild IEs in firmware, parse the
> IEs for HT/VHT capabilities and the respective membership selector
> in the (extended) supported rates. This avoids duplicating the same
> code into all drivers that need this information.
> 

Applied.

johannes
