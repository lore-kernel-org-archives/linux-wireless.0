Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39526 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941371AbcJ0NyO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 09:54:14 -0400
Message-ID: <1477570815.4534.2.camel@sipsolutions.net> (sfid-20161027_162143_190855_B81702CA)
Subject: Re: [PATCH v6 3/4] cfg80211: configure multicast to unicast for AP
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        netdev@vger.kernel.org
Date: Thu, 27 Oct 2016 14:20:15 +0200
In-Reply-To: <1476119543-24509-3-git-send-email-michael-dev@fami-braun.de>
References: <1476119543-24509-1-git-send-email-michael-dev@fami-braun.de>
         <1476119543-24509-3-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-10 at 19:12 +0200, Michael Braun wrote:
> This add a userspace toggle to configure multicast to unicast.
> 

I applied this, with a bunch of fixes and documentation improvements.

johannes
