Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [208.74.158.173] ([208.74.158.173]:49877 "EHLO
	mail2.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaEETLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 15:11:52 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id DF82D40A79A
	for <linux-wireless@vger.kernel.org>; Mon,  5 May 2014 12:06:41 -0700 (PDT)
Message-ID: <5367E13C.2020208@candelatech.com> (sfid-20140505_211155_884363_141E505C)
Date: Mon, 05 May 2014 12:06:36 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: How to configure monitor devices for HT80?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to sniff using a monitor interface on ath10k, on channel 36.

I'm seeing lots of packets, but not all that the AP claims to be sending
(when sniffing vap0).  I am not not certain the monitor interface is
using HT80 or not.

Anyone have a working example of the proper iw commands to create
a monitor interface on channel 36 for HT80?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

