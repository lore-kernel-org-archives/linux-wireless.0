Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:35348 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611AbXHODwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 23:52:50 -0400
Date: Tue, 14 Aug 2007 20:51:49 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/4] hostapd: use SIOCSIWGENIE
Message-ID: <20070815035149.GM1415@jm.kir.nu>
References: <20070814093254.021041000@sipsolutions.net> <20070814093409.132987000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070814093409.132987000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2007 at 11:32:56AM +0200, Johannes Berg wrote:
> Use SIOCSIWGENIE instead of PRISM2_HOSTAPD_SET_GENERIC_INFO_ELEM.

Thanks, applied.

-- 
Jouni Malinen                                            PGP id EFC895FA
