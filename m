Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:60708 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbZFWPo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 11:44:29 -0400
Message-ID: <4A40F856.2010501@openwrt.org>
Date: Tue, 23 Jun 2009 17:44:22 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: fix todo lock
References: <1245751007.4184.17.camel@johannes.local> <1245766038.21314.24.camel@johannes.local>
In-Reply-To: <1245766038.21314.24.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg írta:
> The key todo lock can be taken from different locks
> that require it to be _bh to avoid lock inversion
> due to (soft)irqs.
> 
> This should fix the two problems reported by Bob and
> Gabor:
> http://mid.gmane.org/20090619113049.GB18956@hash.localnet
> http://mid.gmane.org/4A3FA376.8020307@openwrt.org
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Bob Copeland <me@bobcopeland.com>
> Cc: Gabor Juhos <juhosg@openwrt.org>
> ---
>  net/mac80211/key.c |   26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)

I will try it ASAP. Thanks!

Gabor

