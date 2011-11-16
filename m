Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:57637 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab1KPXPs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 18:15:48 -0500
Date: Thu, 17 Nov 2011 00:15:42 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] p54spi: Remove FIXME in op_stop
Message-ID: <20111117001542.68459372@milhouse> (sfid-20111117_001551_782034_34E3BDA3)
In-Reply-To: <201111170012.03948.chunkeey@googlemail.com>
References: <20111116235120.4c60c066@milhouse>
	<201111170012.03948.chunkeey@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 17 Nov 2011 00:12:03 +0100
Christian Lamparter <chunkeey@googlemail.com> wrote:
> BTW: I always wondered if it would make sense to have a
> cached rx skb ready in p54spi_rx(). This way we don't
> have to do DMA onto the stack [which is really ugly and
> possibly illegal] and might even get a better rx
> performance. I could write the code but as you know I don't
> have the hardware to test it.

I'll test it, if you can come up with a patch.

-- 
Greetings, Michael.
