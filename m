Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab3KMSa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:30:58 -0500
Message-ID: <1384367454.14578.21.camel@jlt4.sipsolutions.net> (sfid-20131113_193101_214274_031DBF2A)
Subject: Re: [PATCH] mac80211: minstrel_ht: replace some occurences of
 MCS_GROUP_RATES
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Wed, 13 Nov 2013 19:30:54 +0100
In-Reply-To: <1384171975-21111-1-git-send-email-karl.beldan@gmail.com> (sfid-20131111_131318_297014_BC63A3F5)
References: <1384171975-21111-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20131111_131318_297014_BC63A3F5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-11 at 13:12 +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Consecutive MCSes in [8*(NSS-1)->8*NSS[ have the same number NSS of
> streams (except for MCS32 which is mishandled ATM).
> ATM minstrel_ht uses MCS_GROUP_RATES in place of this 8 modulus.
> This change replaces such occurences and by doing so allows for different
> values of MCS_GROUP_RATES (e.g to cope with VHT MCS8,9).

Applied.

johannes

