Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55127
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871Ab0CCJGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 04:06:22 -0500
Date: Wed, 03 Mar 2010 01:06:41 -0800 (PST)
Message-Id: <20100303.010641.04067796.davem@davemloft.net>
To: jpirko@redhat.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	tcpdump-workers@lists.tcpdump.org, proski@gnu.org
Subject: Re: [net-2.6 PATCH] af_packet: move strict addr_len check right
 before dev_[mc/unicast]_[add/del]
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100303064001.GB2648@psychotron.redhat.com>
References: <1267578048.14049.11.camel@mj>
	<20100303064001.GB2648@psychotron.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jiri Pirko <jpirko@redhat.com>
Date: Wed, 3 Mar 2010 07:40:01 +0100

> Subject: [net-2.6 PATCH] af_packet: move strict addr_len check right before dev_[mc/unicast]_[add/del]
> 
> My previous patch 914c8ad2d18b62ad1420f518c0cab0b0b90ab308 incorrectly changed
> the length check in packet_mc_add to be more strict. The problem is that
> userspace is not filling this field (and it stays zeroed) in case of setting
> PACKET_MR_PROMISC or PACKET_MR_ALLMULTI. So move the strict check to the point
> in path where the addr_len must be set correctly.
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>

Applied.
