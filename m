Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:40067 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbYLIQkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 11:40:03 -0500
Date: Tue, 9 Dec 2008 18:39:39 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>
Subject: Re: [PATCH] ath9k: remove fragmentation workaround again
Message-ID: <20081209163939.GA7947@jm.kir.nu> (sfid-20081209_174007_214157_057035BB)
References: <1228821974.22164.201.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1228821974.22164.201.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 09, 2008 at 12:26:14PM +0100, Johannes Berg wrote:
> Looking at the RC algorithm this is no longer necessary.

> Untested, but the error that used to happen will no longer happen since
> now the sub-structure is assigned by the driver, in rate_driver_data,
> per fragment.

Thanks! Based on a quick test, fragmentation was working with this
patch. I never tested the old issue, so I'm not sure what exactly was
failing, but anyway, I do see fragments in a sniffer log and the device
did not crash ;-).

-- 
Jouni Malinen                                            PGP id EFC895FA
