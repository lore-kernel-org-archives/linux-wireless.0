Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49549 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554AbXJOOC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 10:02:58 -0400
Date: Mon, 15 Oct 2007 07:02:17 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Anton Blanchard <anton@samba.org>
Cc: Larry.Finger@lwfinger.net, mb@bu3sch.de, st3@riseup.net,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] jiffies_round -> jiffies_round_relative conversion -
 b43/b43legacy
Message-ID: <20071015070217.34c59728@laptopd505.fenrus.org> (sfid-20071015_150310_921686_5035F739)
In-Reply-To: <20071015054223.GD3257@kryten>
References: <20071015053428.GA3257@kryten>
	<20071015053801.GB3257@kryten>
	<20071015054034.GC3257@kryten>
	<20071015054223.GD3257@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 15 Oct 2007 00:42:23 -0500
Anton Blanchard <anton@samba.org> wrote:

> 
> When rounding a relative timeout we need to use
> round_jiffies_relative(). 
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
