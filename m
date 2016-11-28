Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42756 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754278AbcK1NPr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 08:15:47 -0500
Message-ID: <1480338942.8107.38.camel@sipsolutions.net> (sfid-20161128_141559_002598_18B911F6)
Subject: Re: [PATCH 0/4] Fix -Wunused-but-set-variable in net/mac80211/
From: Johannes Berg <johannes@sipsolutions.net>
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Marek Kwaczynski <marek.kwaczynski@tieto.com>,
        David Spinadel <david.spinadel@intel.com>,
        Alexander Bondar <alexander.bondar@intel.com>,
        Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 28 Nov 2016 14:15:42 +0100
In-Reply-To: <cover.1479962513.git.kirtika@chromium.org> (sfid-20161124_054535_974361_648CC55D)
References: <cover.1479962513.git.kirtika@chromium.org>
         (sfid-20161124_054535_974361_648CC55D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-11-23 at 20:45 -0800, Kirtika Ruchandani wrote:
> This patchset is part of the effort led by Arnd Bergmann to clean up
> warnings in the kernel. This and following patchsets will focus on
> "-Wunused-but-set-variable" as it among the noisier ones. These were
> found compiling with W=1.

All four applied, thanks.

johannes
