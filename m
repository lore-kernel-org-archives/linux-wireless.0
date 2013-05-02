Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58673 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3EBAAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 20:00:33 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r4200WLo024833
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 1 May 2013 17:00:33 -0700
Message-ID: <5181ACA0.808@candelatech.com> (sfid-20130502_020047_306084_9B21A3B6)
Date: Wed, 01 May 2013 17:00:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: iw: BUG:  Lists more than one phy in info request.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running this command on a system with two wiphy devices
(renamed from phy0, phy1), the command below dumps info for
both wiphy0 and wiphy1

iw phy wiphy1 info

iw version is latest from git.

kernel is 3.9.0+

Using the 'standard' iw on Fedora 14 (version 0.9.22)
it behaves as I expected and only dumps info for wiphy1.


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

