Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48641 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964883AbbKDBQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 20:16:00 -0500
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id A02BD40A79A
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2015 17:15:59 -0800 (PST)
From: Ben Greear <greearb@candelatech.com>
Subject: Question STBC and LDPC
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-ID: <56395C4F.1000203@candelatech.com> (sfid-20151104_021603_230638_85595840)
Date: Tue, 3 Nov 2015 17:15:59 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been digging in the guts of ath10k rate-ctrl, and I notice that if
I tell the chip to do NSS of 1 without STBC or LDPC, then it works as I expect
(single stream, MCS-1 encoding).

But, if I do NSS of 1 and STBC and LDPC enabled (VHT-MCS-0, for instance), then
wireshark shows the frame as being a 2-stream packet and double the bandwidth.

Is this expected?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

