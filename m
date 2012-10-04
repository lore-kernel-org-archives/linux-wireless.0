Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53241 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2JDWGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 18:06:21 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q94M6IxJ019709
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 4 Oct 2012 15:06:19 -0700
Message-ID: <506E0859.906@candelatech.com> (sfid-20121005_000629_667091_6E36A839)
Date: Thu, 04 Oct 2012 15:06:17 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Questions on direct-cabling 3x3 MIMO systems (ath9k)
References: <506DDA1D.1090106@candelatech.com>
In-Reply-To: <506DDA1D.1090106@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2012 11:49 AM, Ben Greear wrote:
> I finally got my 3-attenuator system up and running,
> and I'm starting to do some tests.
>
> AP and Station are running 3.5.5+, ath9k ar9380 NICs.
> Channel 157, HT40, no encryption.
>
> One question right away:  Should I expect decent performance
> if I directly cable 2 wifi NICs, where one is acting as AP and
> the other as station?  I'm cabling ch0 to ch0, ch1 to ch1, ch2 to ch2.

Well, to try to answer my own question:

I mainly needed to tune socket tx/rx-buffer sizes, and some similar
things to get the performance up to expected rates, so it was
mostly user error.

Now, I'm still seeing lots of strange issues when running through
the attenuator with lots of attenuation, but at least when things
are configured for low amounts of attenuation, I get good performance
(330+Mbps UDP throughput).

Off to look at excessive crc errors...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

