Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48810 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbaJXQm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 12:42:26 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id E861F40AB7C
	for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 09:42:25 -0700 (PDT)
Message-ID: <544A8171.3000607@candelatech.com> (sfid-20141024_184229_839199_53471630)
Date: Fri, 24 Oct 2014 09:42:25 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Question phy capabilities in 'iw'
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is the capabilities list from an mac80211_hwsim driver.

I am curious what information this is actually trying to convey.

For instance, why is AP in two different places, with different
values (2048 in first section, 8 in second) ?

	valid interface combinations:
		 * #{ IBSS } <= 1, #{ managed, AP, mesh point, P2P-client, P2P-GO } <= 2048,
		   total <= 2048, #channels <= 1
		 * #{ AP } <= 8,
		   total <= 8, #channels <= 1, radar detect widths: { 20 MHz (no HT), 20 MHz, 40 MHz, 80 MHz, 160 MHz }

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

