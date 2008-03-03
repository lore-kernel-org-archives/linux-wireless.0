Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from flatoutfitness.com ([66.178.130.209]:35503 "EHLO www.seiner.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428AbYCCEJu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 23:09:50 -0500
Message-ID: <47CB71CA.7050304@seiner.com> (sfid-20080303_041009_563067_57730AB8)
Date: Sun, 02 Mar 2008 19:34:34 -0800
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Marvel 8385 on a Sharp Zaurus
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a Marvell 8385 card that I am trying to use with a Sharp Zaurus, 
a Xscale CPU.  The card is completely dead after associating.

It associates, but fails to transmit any data.  I applied this patch  
<http://lists.infradead.org/pipermail/libertas-dev/2008-January/001130.html>  
and now the packet counters increment when I check with ifconfig but the 
card still doesn't send or receive any data.

In other words, the card associates nearly instantly, I get good signal 
strength with iwconfig, ifconfig shows the RX counter incrementing if I 
ping it from outside, but no packets are sent in response.

If I ping outside from inside the Zaurus, the TX counter increments, but 
nothing is received on the outside.

Is there anything I can do to help debug this?  I am stuck with this 
card (I need Channel 13) and that's the only card that provides that.

Thanks,

--Yan
