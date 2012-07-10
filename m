Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55469 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2GJTCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 15:02:40 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q6AJ2de7008702
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 12:02:39 -0700
Message-ID: <4FFC7C4F.9020804@candelatech.com> (sfid-20120710_210252_194820_A6A69A50)
Date: Tue, 10 Jul 2012 12:02:39 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Can one program see another's scan-results?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there a way to open a netlink socket and have it receive
all scan results (even those requested by other applications)?

Thanks,
Ben
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


