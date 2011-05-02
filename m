Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44123 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1EBUvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 16:51:52 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p42KppB6026501
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 2 May 2011 13:51:52 -0700
Message-ID: <4DBF1967.9010604@candelatech.com> (sfid-20110502_225155_292362_707E56C8)
Date: Mon, 02 May 2011 13:51:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Looking for 3x3 Atheros NICs using ath9k driver.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

We are trying to find some Atheros NICs that support 3x3
MIMO, but we are having a hard time.

We mistakenly ordered some Ubiquity SR71-A NICs, but those aren't
even supported by ath9k it seems (visible chipset is AR9160-AC1E).
There are some other SR71 NICs that *do* work (AR9160-BC1A), but
hard to order that specific version.

Sparklan seems to make one based on AR9380, but they are not
in stock any place we could find.

Anyone know of any others that are available to the public
in small quantities?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

