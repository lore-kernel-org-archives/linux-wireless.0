Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37181 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763509AbXGYPh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 11:37:26 -0400
Date: Wed, 25 Jul 2007 16:37:25 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [Fwd: [PATCH] libertas: Per-socket mesh-ttl via setsockopt().]
Message-ID: <20070725153725.GB11785@infradead.org>
References: <1185371628.11035.11.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1185371628.11035.11.camel@xo-13-A4-25.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 25, 2007 at 09:53:48AM -0400, Dan Williams wrote:
> Any objections before I push to libertas?

Please post this to netdev to get the deserved amount of flames from
the core developers.  Or to make it short, no way a driver should register
sockops ever, and no way you should be using netfilter code for that.

