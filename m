Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50444 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaAGS3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 13:29:46 -0500
Message-ID: <52CC4799.4080806@candelatech.com> (sfid-20140107_192950_604439_0C389F40)
Date: Tue, 07 Jan 2014 10:29:45 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Duy Tai Nguyen <duytai.cse@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Virtual Network Interface
References: <CAAVw_ZERCJhy4-Qczn36_CywE6_ceRc03BHfpvavn=A=xo=qRA@mail.gmail.com>
In-Reply-To: <CAAVw_ZERCJhy4-Qczn36_CywE6_ceRc03BHfpvavn=A=xo=qRA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2014 05:24 AM, Duy Tai Nguyen wrote:
> Dir sir!
> I'm a student of University of Technology HCMC, When I find whether
> Android is able to support virtual network interface (vif) like vif in
> linux (wireless.kernel.org/en/users/Documentation/iw/vif/)
> I am wondering if you can help me explain some questions below.
> 1. does android kernel support virtual network interface (vif)?
> 2. does 802.11 standard consist of vif?
> 3. does all WiFi cards support vif or only some of them?

The android phone I looked at briefly was running an Atheros
based NIC, but it did not support more than one station VIF.

Possibly other systems can do more, but I think it is not
very likely.

In general, if you want multiple stations vifs, you need
ath9k, and for more than just a few stations, you need a
pci or pci-e based NIC (not USB).

Ath5k might work in some cases, and with proper firmware and
some driver tweaks, ath10k should support some as well.

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

