Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57851 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab1JaVXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 17:23:08 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p9VLN7FN029099
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 14:23:07 -0700
Message-ID: <4EAF11BB.8020500@candelatech.com> (sfid-20111031_222312_543322_D39D421B)
Date: Mon, 31 Oct 2011 14:23:07 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Any way to disable /a/g rates using 'iw'?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I notice the iw dev wlan0 set bitrates takes legacy-2.4
and legacy-5 as an argument.

Is there any way to disable all /a/g rates on 5Ghz?  Basically,
I want to force the interface to only us /b rates even if the
AP it finds is on 5Ghz.  I would expect in this case that it
would just fail to associate.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

