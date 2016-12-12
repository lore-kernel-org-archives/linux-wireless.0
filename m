Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:49143 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbcLLHVr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 02:21:47 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Subject: Re: [PATCH] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20161212002911.5541-1-andrew.zaborowski@intel.com>
Date: Mon, 12 Dec 2016 08:21:44 +0100
Cc: linux-wireless@vger.kernel.org
Message-Id: <8E332BC1-F05E-4771-ABA4-BD6C59449125@holtmann.org> (sfid-20161212_082151_023125_DE8729C7)
References: <20161212002911.5541-1-andrew.zaborowski@intel.com>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrew,

> Disconnect or deauthenticate when the owning socket is closed if this
> flag is supplied to CMD_CONNECT or CMD_AUTHENTICATE.  This may be used
> to ensure userspace daemon doesn't leave an unmanaged connection behind.

I think you have a typo here. The CMD_AUTHENTICATE should be CMD_ASSOCIATE?

Regards

Marcel
