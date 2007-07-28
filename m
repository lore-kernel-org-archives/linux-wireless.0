Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aa014msr.fastwebnet.it ([85.18.95.74]:56379 "EHLO
	aa014msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbXG1QpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2007 12:45:05 -0400
Date: Sat, 28 Jul 2007 22:40:08 +0200
From: Edward Ando <edwardando@fastwebnet.it>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: Removing the prism54 module
Message-ID: <20070728224008.782a3be6@ed.anywhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear All,
I am trying to set up software suspend 2 (TuxOnIce now it seems). This
has decided it wants to remove the prism54 module before starting the
hibernate process.

When it tries to do this, (or when I manually do: "ifconfig eth1
down"), I start getting these messages on all terminals, ad infinitum:

kernel: unregister_netdevice: waiting for eth1 to become free. Usage
count = 4

I asked a bit on #prism54 on freenode, and so I upgraded to
linux 2.6.22.1 from kernel.org, always building prism54 as a module,
but the problem continues.

I have tried doing "ifconfig eth1 down" before rmmod, but this does not
help.

If you have any hints or answers as to what I should do, that would be
great. I am not subscribed, so could you answer to this address please.


Thanks in advance,
Yours,

Edward Ando
