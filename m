Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1JMPAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 11:00:08 -0400
Subject: Re: [PATCH 1/2] nl80211: Add sta_flags to the station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAGXE3d-9VfBm8DdzuQQ71U=1B81g_Ga1BvmJgv-0RZ6UMOSo_A@mail.gmail.com> (sfid-20111013_165441_118328_6E703E64)
References: <1318516240-10033-1-git-send-email-helmut.schaa@googlemail.com>
	 <1318516981.5612.20.camel@jlt3.sipsolutions.net>
	 <CAGXE3d-9VfBm8DdzuQQ71U=1B81g_Ga1BvmJgv-0RZ6UMOSo_A@mail.gmail.com>
	 (sfid-20111013_165441_118328_6E703E64)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 17:00:03 +0200
Message-ID: <1318518003.5612.22.camel@jlt3.sipsolutions.net> (sfid-20111013_170012_113518_F32D5BEA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-13 at 16:54 +0200, Helmut Schaa wrote:
> On Thu, Oct 13, 2011 at 4:43 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Why would we care about the mask here? Wouldn't a u32 attribute with the
> > set flags only make more sense?
> 
> I though about using the mask to tell user space which flags are actually
> used/supported by the driver. There might be nl80211 drivers that can't provide
> all flags and hence want to mask out the flags. Otherwise user space cannot
> decide if a flag is not set or not supported by the driver. Does that sound
> reasonable?

Yeah I was thinking that too, maybe that makes some sense. Not sure
we'll really run into that? Anyway we can keep it, I don't mind.

johannes

