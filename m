Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54869 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbYIZXB5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 19:01:57 -0400
Date: Fri, 26 Sep 2008 16:01:50 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Release of Atheros 802.11abg HAL under the ISC
Message-ID: <20080926230149.GE5972@tesla> (sfid-20080927_010200_666385_90AA58D3)
References: <20080926215701.GC5972@tesla> <48DD687E.5060703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <48DD687E.5060703@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 26, 2008 at 03:55:58PM -0700, Maxim Levitsky wrote:
> If I understand this correctly, madwifi is no longer a non-free driver?

MadWifi is based on a proprietary HAL which is slightly different
than this one, so no, its still non-free. The "free" drivers where
I think focus should be put in is ath5k and ath9k as they are now both
merged as part of the Linux kernel.

  Luis
