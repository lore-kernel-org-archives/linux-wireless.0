Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33511 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaCaEk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 00:40:28 -0400
Received: from [50.54.140.2] (50-54-140-2.evrt.wa.frontiernet.net [50.54.140.2])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id s2V4eOa8017642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 30 Mar 2014 21:40:27 -0700
Message-ID: <5338F1B8.5040305@candelatech.com> (sfid-20140331_064032_592052_FBCD24D0)
Date: Sun, 30 Mar 2014 21:40:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Looking for non-NIC hardware-offload for wpa2 decrypt.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Due to hardware/firmware limitations, it does not appear possible to
have a wifi NIC do hardware decrypt when using multiple stations on a single
NIC (and have both stations connected to the same AP).

This just happens to be one of my favourite things to do, and it kills
performance compared to normal 'Open' throughput.

I am curious if anyone knows of any way to accelerate rx-decrypt, perhaps by
using a specialized hardware board or maybe a feature of certain CPUs?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

