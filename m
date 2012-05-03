Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56913 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab2ECRct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 13:32:49 -0400
Date: Thu, 3 May 2012 13:28:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2012-05-03
Message-ID: <20120503172829.GN9285@tuxdriver.com> (sfid-20120503_193256_240677_0E20CF86)
References: <20120503152206.GL9285@tuxdriver.com>
 <20120503.130516.1008806127286088740.davem@davemloft.net>
 <20120503.131707.112550136096227430.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120503.131707.112550136096227430.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 03, 2012 at 01:17:07PM -0400, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 03 May 2012 13:05:16 -0400 (EDT)
> 
> > Pulled, thanks John.
> 
> Actually, I un-pulled.  The bluetooth guys are sending crap code
> formatting again.
> 
> From 74e05692c9599866d5c8743764544cf77cd1af87 Mon Sep 17 00:00:00 2001
> From: Andre Guedes <andre.guedes@openbossa.org>
> Date: Tue, 6 Mar 2012 19:37:06 -0300
> Subject: [PATCH 007/160] Bluetooth: Check FINDING state in interleaved
>  discovery
> 
> In order to do interleaved discovery we should be in DISCOVERY_
> FINDING state. Otherwise, discovery should be stopped.
> 
> Signed-off-by: Andre Guedes <andre.guedes@openbossa.org>
> Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
>  ...
> -		if (hdev->discovery.type == DISCOV_TYPE_INTERLEAVED) {
> +		if (hdev->discovery.type == DISCOV_TYPE_INTERLEAVED &&
> +				hdev->discovery.state == DISCOVERY_FINDING) {
> 
> Really, we went through this a million times very recently and I'm
> not pulling anything into my tree that has garbage like this in it.
> 
> Sorry.

No, I'm sorry.  I thought we had this worked-out.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
