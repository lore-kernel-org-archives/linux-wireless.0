Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.235]:11292 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbXBDRWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 12:22:16 -0500
Received: by wr-out-0506.google.com with SMTP id i22so1044449wra
        for <linux-wireless@vger.kernel.org>; Sun, 04 Feb 2007 09:22:15 -0800 (PST)
Message-ID: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com>
Date: Sun, 4 Feb 2007 12:22:15 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: SoftMAC vs FullMAC
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Has it been considered to simply treat all wireless hardware as
SoftMAC and to just ignore the FullMAC capabilities?

Doing this would effectively turn all wireless hardware on Linux into
commodities stopping this chaos of all the different implementations.
Network speeds on wireless are not very high, things may even be
faster if done on the main CPU.

Wired networking went through this exact process in the 80's. There
were cards with complete TCP systems running on embedded processors.
Ultimately this shook out to the dumb hardware we have today. This
happened for two reasons, the main CPU was cheaper/faster and there
were fewer interoperability problems when only a couple of stacks were
being used instead of dozens.

Dscape looks to have already started down this path with
implementations for five vendors. Is the plan to do this for all
vendors, including Intel and Atheros?

My specific need is that I am working on an embedded design that
really needs 802.11s, but 11s isn't available yet. I don't want to end
up locked into a hardware vendor's FullMAC implementation with much
more expensive hardware. Currently hardware can run 11s if there is a
host implementation in software.

Meanwhile I am trying to hack something together using OLSR. Is there
a better way to get mesh working?

-- 
Jon Smirl
jonsmirl@gmail.com
