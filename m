Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48262 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaH0Ri1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 13:38:27 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] carl9170: tx: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Date: Wed, 27 Aug 2014 19:38:21 +0200
Message-ID: <3330201.Gf1OWK6m5t@debian64> (sfid-20140827_193852_597623_8D642670)
In-Reply-To: <20140827132730.GA31650@ada>
References: <20140827132730.GA31650@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, August 27, 2014 04:27:30 PM Andreea-Cristina Bernat wrote:
> According to RCU_INIT_POINTER()'s block comment 3.a, it can be used if
> "3.   The referenced data structure has already been exposed to readers either
> at compile time or via rcu_assign_pointer() -and-
>  a.   You have not made -any- reader-visible changes to this structure since
> then".
> [...]
> 
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

[OT: John, will "carl9170: Remove redundant protection check" make it 
in the next round too?]

Regards
Christian
