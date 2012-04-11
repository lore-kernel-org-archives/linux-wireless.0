Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59766 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2DKFnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 01:43:07 -0400
Subject: Re: 3.2.8/amd64 full interrupt hangs and deadlocks under big
 network copies (page allocation failure)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: David Miller <davem@davemloft.net>, Larry.Finger@lwfinger.net,
	bhutchings@solarflare.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20120411052733.GA17352@merlins.org>
References: <20120409.143710.879746943062854492.davem@davemloft.net>
	 <4F83316F.20504@lwfinger.net> <1333998672.3007.245.camel@edumazet-glaptop>
	 <20120409.153452.1284163346306246866.davem@davemloft.net>
	 <1334030180.13293.98.camel@edumazet-glaptop>
	 <20120410051127.GA32048@merlins.org>
	 <1334038263.2907.1.camel@edumazet-glaptop>
	 <20120411052733.GA17352@merlins.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Apr 2012 07:43:00 +0200
Message-ID: <1334122980.5300.2154.camel@edumazet-glaptop> (sfid-20120411_074314_042699_8772E7AA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-10 at 22:27 -0700, Marc MERLIN wrote:
> On Tue, Apr 10, 2012 at 08:11:03AM +0200, Eric Dumazet wrote:
> > Please try following patch, as it solved the problem for me (no more
> > order-1 allocations in tx path)
> 
> I applied our patch to 3.3.1 and cannot reproduce the problem anymore.
> 
> I'll leave a big wireless copy running overnight just in case, but I think
> you fixed it.
> 
> Thanks much,
> Marc

Thanks Marc for bringing this issue.

I have a lenovo T420s laptop and could debug the thing pretty fast.

I'll send two official patches.


