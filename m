Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37167 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbXEYOaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2007 10:30:10 -0400
Date: Fri, 25 May 2007 15:30:05 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, j@w1.fi,
	hostap@shmoo.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] use list_for_each() for iteration in Host AP driver
Message-ID: <20070525143005.GB10669@infradead.org>
References: <20070525125630.GE31790@traven> <20070525130308.GF31790@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070525130308.GF31790@traven>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 25, 2007 at 03:03:08PM +0200, Matthias Kaehlcke wrote:
> Use list_for_each() in the Host AP driver to iterate over the MAC
> restrictions and the STA info lists

please go all the way to a proper list_for_each_entry.  Then again now
that we have mac80211 shouldn't hostap be ported over to it and this code
go away completely?

