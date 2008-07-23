Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:2445 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbYGWKIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 06:08:47 -0400
Received: by nf-out-0910.google.com with SMTP id d3so829178nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 03:08:45 -0700 (PDT)
Date: Wed, 23 Jul 2008 10:13:52 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>, Larry.Finger@lwfinger.net,
	kaber@trash.net, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080723101352.GD4561@ff.dom.local> (sfid-20080723_120858_476566_A3A3C5ED)
References: <20080722.160409.216536011.davem@davemloft.net> <20080723062036.GA4561@ff.dom.local> <20080723.005921.113868915.davem@davemloft.net> <20080723085452.GB4561@ff.dom.local> <1216803786.7257.146.camel@twins> <20080723093459.GC4561@ff.dom.local> <1216806614.7257.152.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1216806614.7257.152.camel@twins>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 11:50:14AM +0200, Peter Zijlstra wrote:
...
> definite NAK on using raw spinlock ops...
> 
> I'll go look at this multiqueue stuff to see if there is anything to be
> done.. David, what would be a good commit to start reading?

...In the case David ever sleeps: I think, the current Linus' git is
good enough (the problem is with netdevice.h: netif_tx_lock()).

Jarek P.
