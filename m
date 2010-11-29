Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50166 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab0K2V3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 16:29:44 -0500
Date: Mon, 29 Nov 2010 16:27:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	Greg KH <greg@kroah.com>
Subject: Re: [PATCH] ath9k_hw: fix endian issues with CTLs on AR9003
Message-ID: <20101129212707.GG8199@tuxdriver.com>
References: <1290279018-29716-1-git-send-email-nbd@openwrt.org>
 <20101122201511.GG2117@tuxdriver.com>
 <4CEAD7FA.1060107@openwrt.org>
 <20101129195038.GD8199@tuxdriver.com>
 <AANLkTimS1hsfoOe9bdgad7kkUPPcMVjd_kB_Ru8kbqt8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTimS1hsfoOe9bdgad7kkUPPcMVjd_kB_Ru8kbqt8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 29, 2010 at 01:19:19PM -0800, Luis R. Rodriguez wrote:
> On Mon, Nov 29, 2010 at 11:50 AM, John W. Linville
> <linville@tuxdriver.com> wrote:

> > After being chided for having an excessive number of patches in -next
> > with "Cc: stable@kernel.org", I would prefer to avoid (or strongly
> > limit) merging such patches that way.
> 
> Is this a bad thing?

The point was that if it was a fix worth of consideration for stable
then it generally ought to be worth of consideration for the current
release.

> Come to think of it we didn't get OTP patches in for 2.6.36 so I am
> not considering we should just disable AR9003 from the PCI ID list for
> ath9k as all cards sold should have it so in that case this patch
> would just need to go to 2.6.37 and not 2.6.36.

Do you perhaps mean "need to go to 2.6.38 and not 2.6.37"?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
