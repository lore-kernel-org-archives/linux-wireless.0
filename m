Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58393 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab0K2TwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 14:52:24 -0500
Date: Mon, 29 Nov 2010 14:51:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k_hw: fix more bitfield related endian issues
Message-ID: <20101129195125.GE8199@tuxdriver.com>
References: <1290280970-37519-1-git-send-email-nbd@openwrt.org>
 <20101122201541.GH2117@tuxdriver.com>
 <4CEADB73.1050205@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CEADB73.1050205@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 22, 2010 at 10:06:59PM +0100, Felix Fietkau wrote:
> On 2010-11-22 9:15 PM, John W. Linville wrote:
> > On Sat, Nov 20, 2010 at 08:22:50PM +0100, Felix Fietkau wrote:
> >> A few LNA control related flags were also specified as a bitfields, however
> >> for some strange reason they were written in big-endian order this time.
> >> Fix this by using flags instead.
> >> 
> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> >> Cc: stable@kenrel.org
> Oops.
> 
> > Why does this merit stable@kernel.org (misspelled, BTW) inclusion?
> Trivial bug that can easily mess up baseband settings in some cases. Not
> sure if it could also mess with tx power.

See my reply to the related bug.  Should this go to 2.6.37?

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
