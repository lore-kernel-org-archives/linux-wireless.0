Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33775 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab2JDStM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 14:49:12 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q94In1CR003060
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 4 Oct 2012 11:49:02 -0700
Message-ID: <506DDA1D.1090106@candelatech.com> (sfid-20121004_204916_633988_0E39C533)
Date: Thu, 04 Oct 2012 11:49:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Questions on direct-cabling 3x3 MIMO systems (ath9k)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I finally got my 3-attenuator system up and running,
and I'm starting to do some tests.

AP and Station are running 3.5.5+, ath9k ar9380 NICs.
Channel 157, HT40, no encryption.

One question right away:  Should I expect decent performance
if I directly cable 2 wifi NICs, where one is acting as AP and
the other as station?  I'm cabling ch0 to ch0, ch1 to ch1, ch2 to ch2.

If I add about 15dBm of attenuation in this setup, max download
speed is about 70Mbps, though the station may train up to 450Mbps
rate.  Signal is reported as -23, and noise at -93.

Throughput stays about the same all the way to signal of -68 or so, though
the trained rate drops to around 270Mbps.

I can't make the signal quality go lower (even by attaching terminators
directly to the antenna mounts on the AP).  Guess I'll need some sort of
box to double-box these systems and hopefully drown out more of the RF.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

