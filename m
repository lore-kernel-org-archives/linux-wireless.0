Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55118
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754679Ab0CCJGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 04:06:10 -0500
Date: Wed, 03 Mar 2010 01:06:28 -0800 (PST)
Message-Id: <20100303.010628.41962003.davem@davemloft.net>
To: jpirko@redhat.com
Cc: linux-wireless@vger.kernel.org, tcpdump-workers@lists.tcpdump.org,
	proski@gnu.org, netdev@vger.kernel.org
Subject: Re: [net-2.6 PATCH] af_packet: move strict addr_len check right
 before dev_[mc/unicast]_[add/del]
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100303090512.GB2961@psychotron.lab.eng.brq.redhat.com>
References: <1267578048.14049.11.camel@mj>
	<20100303064001.GB2648@psychotron.redhat.com>
	<20100303090512.GB2961@psychotron.lab.eng.brq.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jiri Pirko <jpirko@redhat.com>
Date: Wed, 3 Mar 2010 10:05:13 +0100

> Wed, Mar 03, 2010 at 07:40:01AM CET, jpirko@redhat.com wrote:
>>Subject: [net-2.6 PATCH] af_packet: move strict addr_len check right before dev_[mc/unicast]_[add/del]
> 
> Dave please apply this against net-next-2.6. I see that 914c8ad2d18b is still not in
> net-2.6.

Would you relax?

I just rebased net-2.6 and net-next-2.6 after Linus took in my
changes and I just applied your regression fix to my tree and
was about to let you know I applied it.
