Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36661 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758901AbaDKA1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 20:27:30 -0400
Received: by mail-pa0-f41.google.com with SMTP id fa1so4676710pad.28
        for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2014 17:27:29 -0700 (PDT)
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/8] cfg80211: fix possible compile warning in wext-compat.h
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
	<1397117376.4757.8.camel@jlt4.sipsolutions.net>
Date: Fri, 11 Apr 2014 08:27:21 +0800
In-Reply-To: <1397117376.4757.8.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Thu, 10 Apr 2014 10:09:36 +0200")
Message-ID: <87mwfsemmu.fsf@gmail.com> (sfid-20140411_022740_625961_1FB2CD83)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-10 at 10:09:36 +0200, Johannes Berg wrote:
> On Wed, 2014-04-09 at 09:28 +0800, Zhao, Gang wrote:
>> Function cfg80211_wext_freq() is declared in wext-compat.h, but its
>> parameter struct wiphy's declaration is not included there. Actually
>> the parameter is not used in this function, so change it to normal
>> net_device.
>
> I applied this, but the netdev argument is also unused so I just removed
> it entirely.

I added netdev argument just to be consistent with other functions. It's
OK to remove it.

>
> johannes
