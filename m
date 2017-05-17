Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40178 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753814AbdEQMZt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 08:25:49 -0400
Message-ID: <1495023947.2442.2.camel@sipsolutions.net> (sfid-20170517_142555_918125_74AB9CD4)
Subject: Re: [PATCH v2] mac80211: strictly check mesh address extension mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
Date: Wed, 17 May 2017 14:25:47 +0200
In-Reply-To: <1494823315-26575-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1494823315-26575-1-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2017-05-14 at 21:41 -0700, Rajkumar Manoharan wrote:
> Mesh forwarding path checks for address extension mode to fetch
> appropriate proxied address and MPP address. Existing condition
> that looks for 6 address format is not strict enough so that
> frames with improper values are processed and invalid entries
> are added into MPP table. Fix that by adding a stricter check before
> processing the packet.
> 
> Per IEEE Std 802.11s-2011 spec. Table 7-6g1 lists address extension
> mode 0x3 as reserved one. And also Table Table 9-13 does not specify
> 0x3 as valid address field.

Yeah ...

applied, thanks.

johannes
