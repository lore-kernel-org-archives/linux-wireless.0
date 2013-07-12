Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:50970
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964819Ab3GLNiN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 09:38:13 -0400
Received: from mail15-co1 (localhost [127.0.0.1])	by mail15-co1-R.bigfish.com
 (Postfix) with ESMTP id D65BE2C07CD	for <linux-wireless@vger.kernel.org>;
 Fri, 12 Jul 2013 13:38:11 +0000 (UTC)
Received: from CO1EHSMHS026.bigfish.com (unknown [10.243.78.235])	by
 mail15-co1.bigfish.com (Postfix) with ESMTP id 38460C80568	for
 <linux-wireless@vger.kernel.org>; Fri, 12 Jul 2013 13:37:52 +0000 (UTC)
From: "Barlow-Bignell, James" <j.barlow-bignell.12@ucl.ac.uk>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 802.11 MAC fails
Date: Fri, 12 Jul 2013 13:37:48 +0000
Message-ID: <BD39EC6086283F4DBB4DBCAB112BCDDA21FA1915@DBXPRD0111MB495.eurprd01.prod.exchangelabs.com> (sfid-20130712_153816_419153_A78256D8)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hiya

Does anyone familiar with the 802.11 mac code know what the kernel currently does with frames which fail to send after reaching the re-transmit limit?

I would imagine that either the mac layer reports the failure to the upper layer (e.g. TCP), or the failure is simply swallowed and upper layers should rely on ACK timeouts if necessary.

Many thanks
