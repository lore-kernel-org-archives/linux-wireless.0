Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:62220 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab1HAVKb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 17:10:31 -0400
Message-ID: <4E371645.9080407@gnu.org> (sfid-20110801_231036_840655_7CDAABDD)
Date: Mon, 01 Aug 2011 17:10:29 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Martin Partridge <martin_partridge@btconnect.com>,
	linux-wireless@vger.kernel.org
Subject: Re: help with wg511v2
References: <op.vzcrpnuuhgplxr@melanie> <201107290147.26919.chunkeey@googlemail.com> <op.vzexmjbnhgplxr@melanie> <201107301312.17758.chunkeey@googlemail.com>
In-Reply-To: <201107301312.17758.chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/30/2011 07:12 AM, Christian Lamparter wrote:
> On Saturday 30 July 2011 05:36:09 Martin Partridge wrote:
>> 02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88w8335 [Libertas] 802.11b/g Wireless (rev 03)
>      ^^^^^^^
>
> Ah, this explains it everything. You are unfortunately a victim of Netgear's stupid
> naming scam. The situation is explained at http://daemonizer.de/prism54/wg511/
> The upshot is: there are two WG511 v2 versions, but only the first v2 works with
> p54. The second one needs a driver from marvell.

The driver is called mrv8k, but it's not in the Linux tree, not even in 
staging.  I don't know why.  Perhaps it's not functional.

Several pages recommend disabling mrv8k and using ndiswrapper with 
Windows drivers.  Until ndiswrapper 1.57 is released, you'll need the 
current snapshot from subversion, as ndiswrapper 1.56 doesn't compile 
for Linux 2.6.35 and newer.

-- 
Regards,
Pavel Roskin
