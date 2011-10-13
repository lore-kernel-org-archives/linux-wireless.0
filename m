Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62325 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab1JMOyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 10:54:09 -0400
Received: by ggnv2 with SMTP id v2so92233ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2011 07:54:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318516981.5612.20.camel@jlt3.sipsolutions.net>
References: <1318516240-10033-1-git-send-email-helmut.schaa@googlemail.com>
	<1318516981.5612.20.camel@jlt3.sipsolutions.net>
Date: Thu, 13 Oct 2011 16:54:08 +0200
Message-ID: <CAGXE3d-9VfBm8DdzuQQ71U=1B81g_Ga1BvmJgv-0RZ6UMOSo_A@mail.gmail.com> (sfid-20111013_165413_873916_01887311)
Subject: Re: [PATCH 1/2] nl80211: Add sta_flags to the station info
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 13, 2011 at 4:43 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Why would we care about the mask here? Wouldn't a u32 attribute with the
> set flags only make more sense?

I though about using the mask to tell user space which flags are actually
used/supported by the driver. There might be nl80211 drivers that can't provide
all flags and hence want to mask out the flags. Otherwise user space cannot
decide if a flag is not set or not supported by the driver. Does that sound
reasonable?

Helmut
