Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42494 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751347AbdCaGdF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 02:33:05 -0400
Message-ID: <1490941983.24283.3.camel@sipsolutions.net> (sfid-20170331_083309_613606_FAA0DA0B)
Subject: Re: [PATCH 2/2] cfg80211: Add support for FILS shared key
 authentication offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>
Date: Fri, 31 Mar 2017 08:33:03 +0200
In-Reply-To: <1490908954-5412-2-git-send-email-jouni@qca.qualcomm.com>
References: <1490908954-5412-1-git-send-email-jouni@qca.qualcomm.com>
         <1490908954-5412-2-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-31 at 00:22 +0300, Jouni Malinen wrote:
> From: Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>
> 
> Enhance nl80211 and cfg80211 connect request and response APIs to
> support FILS shared key authentication offload. The new nl80211
> attributes can be used to provide additional information to the
> driver
> to establish a FILS connection. Also enhance the set/del PMKSA to
> allow
> support for adding and deleting PMKSA based on FILS cache identifier.
> 
> Add a new feature flag that drivers can use to advertize support for
> FILS shared key authentication and association in station mode when
> using their own SME.
> 

Also applied.

johannes
