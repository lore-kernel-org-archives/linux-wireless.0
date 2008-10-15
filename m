Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60851 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbYJOTus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 15:50:48 -0400
Date: Wed, 15 Oct 2008 15:48:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] minstrel: improve performance for non-MRR drivers
Message-ID: <20081015194803.GB27688@tuxdriver.com> (sfid-20081015_215118_068676_4D603644)
References: <48F624D7.4040802@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48F624D7.4040802@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 07:13:59PM +0200, Felix Fietkau wrote:
> This patch enhances minstrel's performance for non-MRR setups,
> by preventing it from sampling slower rates with >95% success
> probability and by putting at least 1 non-sample frame between
> several sample frames.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
> This patch depends on the rate control API rewrite patch.

Hah!  Which one...? :-)

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
