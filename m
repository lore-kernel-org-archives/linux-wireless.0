Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33833 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752791AbcIDDWl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 23:22:41 -0400
Received: by mail-it0-f66.google.com with SMTP id e124so5809550ith.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Sep 2016 20:22:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160811103816.1695-1-maxim.altshul@ti.com>
References: <20160811103816.1695-1-maxim.altshul@ti.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 4 Sep 2016 13:22:20 +1000
Message-ID: <CAGRGNgVLbaxPm5oh7hPohMDi1a5RUiMY8VL=71YcnUY_7TJ1pQ@mail.gmail.com> (sfid-20160904_052245_487368_766E1072)
Subject: Re: [PATCH] Add protection to get_expected_throughput opcode
To: Maxim Altshul <maxim.altshul@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Maxim,

On Thu, Aug 11, 2016 at 8:38 PM, Maxim Altshul <maxim.altshul@ti.com> wrote:
> The patch is done with respect to the patch that was applied:
> [PATCH v3] mac80211: mesh: Add support for HW RC implementation
>
> 1. Patch adds protection as we discussed
> 2. Patch changes the function call that is made in the mesh patch
> to comply with the change.
>
> Maxim Altshul (1):
>   mac80211: Add protection to get_expected_throughput opcode
>
>  net/mac80211/driver-ops.h | 8 ++++----
>  net/mac80211/sta_info.c   | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)

Where's the patch?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
