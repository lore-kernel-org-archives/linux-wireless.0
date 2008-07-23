Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYGWQ37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 12:29:59 -0400
Date: Wed, 23 Jul 2008 12:29:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k: some more yummy patches
Message-ID: <20080723162956.GA8742@infradead.org> (sfid-20080723_183002_586345_23FA2B3D)
References: <43e72e890807230913v10198fbcqeecfe770490aef65@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890807230913v10198fbcqeecfe770490aef65@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 09:13:37AM -0700, Luis R. Rodriguez wrote:
> Some more yummmy patches, specially if you are interested in IBSS.
> These are committed into ath9k git as well.
> 
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2008-07-23/

Btw I had a quick look over the driver, and it's quite huge..  Why does
the driver have it's own regdomain support?  Also there seems to be
quite some useless hal style abstractions and types.  Do you plan to
kill those?

And a lot of macros that want replacing by proper C code.

