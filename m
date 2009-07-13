Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:57411 "EHLO
	postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZGMGpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 02:45:12 -0400
Received: from [10.0.1.10] (dslb-084-063-085-116.pools.arcor-ip.net [84.63.85.116])
	by postfix.iai.uni-bonn.de (Postfix) with ESMTP id 5C2255C828
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 08:32:24 +0200 (MEST)
	(envelope-from schneid5@cs.uni-bonn.de)
	(envelope-to linux-wireless@vger.kernel.org) (1)
	(internal use: ta=1, tu=1, te=1, am=P, au=schneid5)
Message-Id: <0D620DB9-0DF4-41BB-8686-5BC910F88C79@cs.uni-bonn.de>
From: Tim Schneider <schneid5@cs.uni-bonn.de>
To: Linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Reading the RSSI from a Kernel Module
Date: Mon, 13 Jul 2009 08:32:23 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to write a Kernel Module with an implementation of a new  
TCP-Algorithm. Since I need to know the RSSI-Value (Received Signal  
Strength indication) of the sent package, I extended the Pluggable  
Congestion Control Mechanism by a new function which is called right  
after the package is send. At that point, I need to read the RSSI-Value.

I'm now trying to somehow access that value, but I can't figure out  
how. I've come as far, that I found out about the Wirelless  
Extensions, which seem to be very promising. In the header file the  
author states, that this mechanism can be used by both user-space apps  
and kernel modules. Unfortunately nobody seems to ever have used it in  
kernel space, since I can't find any documentations about it. I've  
already asked this question on the netdev mailing list. They told me,  
that there is a new system  with a netlink based cfg80211/nl80211  
interface in development right now , which is supposed to replace the  
wireless extensions in the future. They also told me, that this would  
probably be the correct mailing list for this kind of question.

I would be very glad, if somebody could give me link to a page  
containing informations about this topic, or even just a hint that  
could help me.

Thank you

Tim Schneider

