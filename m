Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49537 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765266AbXJOOCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 10:02:31 -0400
Date: Mon, 15 Oct 2007 07:01:54 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Anton Blanchard <anton@samba.org>
Cc: rt2400-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] jiffies_round -> jiffies_round_relative conversion -
 rt2x00
Message-ID: <20071015070154.4002340f@laptopd505.fenrus.org> (sfid-20071015_150310_311669_C6DE53C5)
In-Reply-To: <20071015054034.GC3257@kryten>
References: <20071015053428.GA3257@kryten>
	<20071015053801.GB3257@kryten>
	<20071015054034.GC3257@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 15 Oct 2007 00:40:34 -0500
Anton Blanchard <anton@samba.org> wrote:

> 
> When rounding a relative timeout we need to use
> round_jiffies_relative(). 
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
