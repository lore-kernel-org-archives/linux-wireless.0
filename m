Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54749
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbZDUIns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 04:43:48 -0400
Received: from localhost (localhost [127.0.0.1])
	by sunset.davemloft.net (Postfix) with ESMTP id C5F21C8C0DE
	for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2009 01:43:40 -0700 (PDT)
Date: Tue, 21 Apr 2009 01:43:40 -0700 (PDT)
Message-Id: <20090421.014340.235726123.davem@davemloft.net> (sfid-20090421_104352_471569_13F52D83)
To: linux-wireless@vger.kernel.org
Subject: warning in current tree
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This appears in net-2.6 as well as net-next-2.6, could someone
please fix it up?  Thanks!

drivers/net/wireless/mwl8k.c:897: warning: large integer implicitly truncated to unsigned type
