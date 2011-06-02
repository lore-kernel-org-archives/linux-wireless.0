Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55574 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1FBTQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 15:16:00 -0400
Received: by qwk3 with SMTP id 3so516478qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2011 12:16:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307042072.3738.4.camel@jlt3.sipsolutions.net>
References: <1305586296-23147-1-git-send-email-greearb@candelatech.com>
 <1305759738.8827.6.camel@jlt3.sipsolutions.net> <4DD4569C.7080303@candelatech.com>
 <BANLkTinozbG2SfOCRd1U__8-Pz9-8HCkPQ@mail.gmail.com> <1307042072.3738.4.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 2 Jun 2011 12:15:40 -0700
Message-ID: <BANLkTinhYwNjSKwS1YhZxq3_HxJTn1dkNg@mail.gmail.com> (sfid-20110602_211606_578028_B149C900)
Subject: Re: [PATCH v2] wireless: Support can-scan-one logic.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 2, 2011 at 12:14 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-06-02 at 12:12 -0700, Luis R. Rodriguez wrote:
>
>> Since this shit was merged can you add a respective documentation
>> extension for the command for nl80211.h?
>
> You're kidding, right? The -1 crap was merged? Breaking all drivers
> other than mac80211?
commit 718ab883ccd1258c1e5c150edfb407880df9eeaa
Author: Ben Greear <greearb@candelatech.com>
Date:   Mon May 16 15:51:36 2011 -0700

    wireless: Support can-scan-one logic.

    Enable this by passing a -1 for a scan frequency.

    When enabled, the system will only scan the current active
    channel if at least one VIF is actively using it.  If no
    VIFS are active or this flag is disabled, then default
    behaviour is used.

    This helps when using multiple STA interfaces that otherwise might
    constantly be trying to scan all channels.

    Signed-off-by: Ben Greear <greearb@candelatech.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

My baby just turned.

  Luis
