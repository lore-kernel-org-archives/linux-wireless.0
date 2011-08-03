Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37990 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab1HCFdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 01:33:41 -0400
Received: from [50.47.228.156] (50-47-228-156.evrt.wa.frontiernet.net [50.47.228.156])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p735XdVd000952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 2 Aug 2011 22:33:40 -0700
Message-ID: <4E38DDB3.1030801@candelatech.com> (sfid-20110803_073359_906461_41F4F32C)
Date: Tue, 02 Aug 2011 22:33:39 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Bridging wired to STA interfaces.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have some interest in being able to bridge wired systems to
(virtual) STA interfaces, primarily for using third-party
traffic generation tools over virtual stations.

I was thinking of writing a sta-bridge module that mapped
incoming packets on a wired interface to a STA with MAC
that matched the source MAC of the packet.  All packets
received on the STA would be forwarded un-modified out
the wired port.

I think this would allow someone to create a STA interface
with MAC matching a PC connected to the wired port and effectively
have it be a transparent bridge between STA and PC.

Has anyone attempted something like this before?

Any interest in having this feature in the upstream kernel?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
