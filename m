Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:41111 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751857AbZIHRxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 13:53:18 -0400
Received: from [192.168.1.3] (mail.redfish-solutions.com [192.168.1.3])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.3/8.14.3) with ESMTP id n88HrHbV015719
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2009 11:53:21 -0600
Message-ID: <4AA69A0D.3040608@redfish-solutions.com>
Date: Tue, 08 Sep 2009 11:53:17 -0600
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: AP: ath5k + hostapd occasionally sulks
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I pulled compat-wireless from GIT last night (or about 1:30am mountain,
really) and rebuilt a 2.6.27.29 kernel.

I'm seeing a lot of:

Sep  8 11:44:09 pbx user.err kernel: ath5k phy0: no further txbuf available, dropping packet


one every 10 seconds, in fact.  This is with an Engenius EMP-8062+ card:

00:11.0 Ethernet controller: Atheros Communications Inc. AR5413 802.11abg NIC (rev 01)
	Subsystem: Atheros Communications Inc. EnGenius EMP-8602 (400mw) or Compex WLM54AG
	Flags: bus master, medium devsel, latency 168, IRQ 15
	Memory at a0010000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: ath5k
	Kernel modules: ath5k



Is this a known issue? Jon posted the same question, but I didn't see an
answer to his question...

And like him, I'm also using hostapd (but I pulled a GIT at the same
time last night).

I'll probably have to reboot regularly, since this is on an embedded box
with limited CF filesystem, and I can't overflow my /var partition...

Thanks,

-Philip



