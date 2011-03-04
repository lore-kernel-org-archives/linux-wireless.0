Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39892 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab1CDOOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 09:14:38 -0500
Message-ID: <4D70F3CD.3040009@candelatech.com>
Date: Fri, 04 Mar 2011 06:14:37 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: jpo234 <pommnitz@yahoo.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k:  Put hardware in PROMISC mode if there is more
 than 1 stations.
References: <1299191945-13257-1-git-send-email-greearb@candelatech.com> <loom.20110304T110306-345@post.gmane.org>
In-Reply-To: <loom.20110304T110306-345@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/04/2011 02:04 AM, jpo234 wrote:
> | From: Ben Greear<greearb@...>
> |
> | It seems ath5k has issues receiving broadcast packets (ARPs) when
> | using multiple STA interfaces associated with multiple APs.
> | This patch ensures the NIC is always in PROMISC mode if there
> | are more than 1 stations associated.
>
> Is this a band aid or a real fix?

I don't know.  It definitely makes things work, but it smells
like a hack.  Considering ath9k works fine, it must be something
in the ath5k driver, but I can't see any other problems.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
