Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZADH1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 02:27:09 -0500
Date: Sun, 4 Jan 2009 02:27:06 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [RFC 02/12] ath9k: introduce bus specific register access
	routines
Message-ID: <20090104072706.GB12905@infradead.org> (sfid-20090104_082719_045951_E4A50763)
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org> <1230990262-22923-3-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1230990262-22923-3-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 03, 2009 at 02:44:12PM +0100, Gabor Juhos wrote:
> The AHB bus will require different code for register access, so we make
> them replaceable as well.

What kind of different code?  ioread*/iowrite* are supposed to be bus-agnostic.

