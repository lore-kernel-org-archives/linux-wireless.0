Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55531 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0HWOOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:14:32 -0400
Date: Mon, 23 Aug 2010 10:14:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn fails to associate on 2.6.36-rc2
Message-ID: <20100823141432.GA29902@infradead.org>
References: <20100823110247.GA3198@infradead.org>
 <1282572681.20674.3.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1282572681.20674.3.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 23, 2010 at 07:11:21AM -0700, Guy, Wey-Yi wrote:
> it is kind of strange, the connection can stay if you have background
> ping going?

Yes (that's on a kernel up to 2.6.35). Otherwise it drops a lot, up
to ca 2.6.32 it kept working.  See the linux-wireless archives for my
report from back then.

> could you give more description on your problem, band/channel/...
> you also can turn on the debug flag debug=0x43fff to capture the current
> status of iwlwifi. it do require you compile kernel with full debugging
> support.

I don't know what you mean with full kernel debugging.  iwlagn
debugging, mac80211 debugging?  Just tell me the options and I'll run
with it.
