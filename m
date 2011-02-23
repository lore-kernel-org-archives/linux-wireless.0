Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48681 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab1BWVaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 16:30:39 -0500
Date: Wed, 23 Feb 2011 16:21:32 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] ath9k: correct ath9k_hw_set_interrupts
Message-ID: <20110223212132.GC2729@tuxdriver.com>
References: <20110221140210.GA5996@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110221140210.GA5996@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 21, 2011 at 03:02:41PM +0100, Stanislaw Gruszka wrote:
> Commit 4df3071ebd92ef7115b409da64d0eb405d24a631 "ath9k_hw: optimize
> interrupt mask changes", changed ath9k_hw_set_interrupts function to
> enable interrupts regardless of function argument, what could possibly
> be wrong. Correct that behaviour and check "ints" arguments before
> enabling interrupts, also disable interrupts if ints do not have
> ATH9K_INT_GLOBAL flag set.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Should this be Cc: stable@kernel.org?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
