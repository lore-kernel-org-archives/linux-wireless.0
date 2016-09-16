Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58780 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933598AbcIPLAY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 07:00:24 -0400
Message-ID: <1474023619.5481.5.camel@sipsolutions.net> (sfid-20160916_130031_572183_422F4A24)
Subject: Re: [PATCH v2 1/9] cfg80211: add start / stop NAN commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Sep 2016 13:00:19 +0200
In-Reply-To: <6bfd6007-8650-3c75-2e90-c2c94202e2b9@broadcom.com> (sfid-20160916_125846_382444_46B5BAF2)
References: <20160916083321.5840-1-luca@coelho.fi>
         <20160916083321.5840-2-luca@coelho.fi>
         <6bfd6007-8650-3c75-2e90-c2c94202e2b9@broadcom.com>
         (sfid-20160916_125846_382444_46B5BAF2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I think NUM_NL80211_IFTYPES should not be in the switch. If it must I
> would leave it as last one here.
> 

It just suppresses compiler warnings :)

johannes
