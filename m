Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38631 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaBLPos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 10:44:48 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21243.38599.474190.76004@gargle.gargle.HOWL> (sfid-20140212_164500_389721_A819DC9C)
Date: Wed, 12 Feb 2014 21:14:07 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k: implement p2p client powersave support
In-Reply-To: <52FB941E.1020300@openwrt.org>
References: <1392113890-5097-1-git-send-email-nbd@openwrt.org>
	<1392113890-5097-2-git-send-email-nbd@openwrt.org>
	<21243.36697.649170.35540@gargle.gargle.HOWL>
	<52FB941E.1020300@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> It only allocates a very small struct. Doing this in the interface
> add/remove callback means I'd have to handle interface change as well. I
> figured keeping it simple is better than micro-optimizing a single small
> memory allocation.

I think doing this in the interface callbacks would be cleaner since
this won't be required for normal ap/sta operations at all.

Sujith

