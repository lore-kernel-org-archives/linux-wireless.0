Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43097 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab0KVU3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 15:29:45 -0500
Date: Mon, 22 Nov 2010 15:15:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k_hw: fix endian issues with CTLs on AR9003
Message-ID: <20101122201511.GG2117@tuxdriver.com>
References: <1290279018-29716-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1290279018-29716-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 20, 2010 at 07:50:18PM +0100, Felix Fietkau wrote:
> Parsing data using bitfields is messy, because it makes endian handling
> much harder. AR9002 and earlier got it right, AR9003 got it wrong.
> Fix it by getting rid of the CTL related bitfields entirely and use
> masks instead.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@kernel.org

Why does this merit stable consideration?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
