Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43095 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab0KVU3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 15:29:45 -0500
Date: Mon, 22 Nov 2010 15:15:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k_hw: fix more bitfield related endian issues
Message-ID: <20101122201541.GH2117@tuxdriver.com>
References: <1290280970-37519-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1290280970-37519-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 20, 2010 at 08:22:50PM +0100, Felix Fietkau wrote:
> A few LNA control related flags were also specified as a bitfields, however
> for some strange reason they were written in big-endian order this time.
> Fix this by using flags instead.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@kenrel.org

Why does this merit stable@kernel.org (misspelled, BTW) inclusion?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
