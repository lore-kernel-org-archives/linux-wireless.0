Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:48537 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab1C2UcX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 16:32:23 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-5.nexicom.net [98.124.36.5])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p2TKWMPs023604
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 16:32:23 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id AE4D51E0602
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 16:32:21 -0400 (EDT)
Message-ID: <4D9241D9.5010204@lockie.ca>
Date: Tue, 29 Mar 2011 16:32:25 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: width is 32 bits
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does it cause a problem that the width is 32 bits and I use a 64 bit
system (I can't run 32 bit software)?

$ sudo lshw -C network
  *-network               
       description: Wireless interface
       product: AR5008 Wireless Network Adapter
       vendor: Atheros Communications Inc.
       physical id: 9
       bus info: pci@0000:02:09.0
       logical name: wlan0
       version: 01
       serial: 00:19:5b:45:2c:5f
       width: 32 bits
       clock: 66MHz
       capabilities: bus_master cap_list ethernet physical wireless
       configuration: broadcast=yes driver=ath9k driverversion=2.6.38.2
firmware=N/A latency=168 link=no multicast=yes wireless=IEEE
802.11bgn                  
       resources: irq:17 memory:f9fe0000-f9feffff

