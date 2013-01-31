Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54693 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab3AaCBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 21:01:48 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r0V21lFZ001644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2013 18:01:48 -0800
Message-ID: <5109D08B.1030707@candelatech.com> (sfid-20130131_030152_305192_AC354DAC)
Date: Wed, 30 Jan 2013 18:01:47 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Any way to see current CQM RSSI value?
References: <5109BBCE.4090605@candelatech.com>
In-Reply-To: <5109BBCE.4090605@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2013 04:33 PM, Ben Greear wrote:
> I'm seeing lots of these types of wireless events:
>
> 2013-01-30 16:30:59.330  1.1:  sta2 (phy #0): connection quality monitor event: RSSI went below threshold
> 2013-01-30 16:30:59.330  1.1:  sta4 (phy #0): connection quality monitor event: RSSI went below threshold
> 2013-01-30 16:30:59.330  1.1:  sta6 (phy #0): connection quality monitor event: RSSI went below threshold
> 2013-01-30 16:31:03.380  1.1:  sta3 (phy #0): connection quality monitor event: RSSI went below threshold
> 2013-01-30 16:31:06.342  1.1:  sta5 (phy #0): connection quality monitor event: RSSI went below threshold
> 2013-01-30 16:31:06.360  1.1:  sta7 (phy #0): connection quality monitor event: RSSI went below threshold

I think now this is just a printout issue in iw, it seems the real problem is NL80211_CQM_RSSI_BEACON_LOSS_EVENT,
not RSSI issue.

I'll work up a patch for iw tomorrow if upstream hasn't fixed it yet.

Would still be nice to display the current CQM settings of course...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

