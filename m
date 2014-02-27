Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49659 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaB0UTW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 15:19:22 -0500
Message-ID: <530F9DB1.5080205@candelatech.com> (sfid-20140227_211944_099789_2A85EFF2)
Date: Thu, 27 Feb 2014 12:18:57 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Ath10k throughput report with up to 32 stations.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the msdu chaining patch I just posted, I am finally getting
decent throughput when using up to 32 station vifs.

I'm hoping I can optimize things better, and I need to get things like tx/rx
train rate reporting working for the station vifs, but I figure these graphs
might be interesting to people.

Basically, the AP is stock firmware and kernel, clients are my modified
firmware and ath10k is patched a bit as well.  All 32 stations are running
on a single NIC in the station machine.  NICs are WLE900VX.

Single station throughput is not on this graph, but it is around 375-400Mbps.

http://www.candelatech.com/examples/wifi-capacity-32-ath10k-tcp-open-ota/

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

