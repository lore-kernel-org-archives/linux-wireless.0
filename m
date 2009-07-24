Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55043 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZGXPXv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 11:23:51 -0400
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
From: Pavel Roskin <proski@gnu.org>
To: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <wfzlau7co1.fsf@calligramme.charmers>
References: <wfljmpm4xl.fsf@calligramme.charmers>
	 <1247762215.4235.21.camel@mj> <wf1vogmujw.fsf@calligramme.charmers>
	 <1247775641.6841.16.camel@mj>   <wfzlau7co1.fsf@calligramme.charmers>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 11:23:50 -0400
Message-Id: <1248449030.21715.23.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-24 at 08:39 +0100, Jon Fairbairn wrote:

> lspci -nn says
> 04:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR242x
>            802.11abg Wireless PCI Express Adapter [168c:001c] (rev 01)

Great!

> Does that want to go on the wiki? (I can't access it right now:
> http://wireless.kernel.org/en/users/Devices * Connection to 83.246.72.84
> Failed )

Yes, it was down, but now it's working.  I've added your device:
http://wireless.kernel.org/en/users/Devices/PCI

I assume the subvendor/subsystem ID is 147b:1033, as reported elsewhere
and as "lspci -vnn" would show.

I tried to add a link for PCI Express devices, but I don't have
permissions to reorganize the Wiki to have a separate table.  From the
users' perspective, PCI and PCI Express are different busses and should
be listed separately.

-- 
Regards,
Pavel Roskin
