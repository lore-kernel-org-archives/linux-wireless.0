Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from j1.co.za ([52.0.118.132]:54002 "EHLO j1.co.za"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795AbcDLGb1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 02:31:27 -0400
Received: from [10.0.0.111] (169-0-102-122.ip.afrihost.co.za [169.0.102.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by j1.co.za (Postfix) with ESMTPSA id A2C1440217
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2016 06:31:25 +0000 (UTC)
Subject: Re: hardware restart on Intel 7260
References: <570BB012.8060709@j1.co.za>
 <CANUX_P0+9ALJa4WexPCpW5a3YxKDPL3wZGta-F2VrgOBU6VcXA@mail.gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
From: Johann Haarhoff <johann@j1.co.za>
Message-ID: <570C963A.9070300@j1.co.za> (sfid-20160412_083145_142015_D386CF63)
Date: Tue, 12 Apr 2016 08:31:22 +0200
MIME-Version: 1.0
In-Reply-To: <CANUX_P0+9ALJa4WexPCpW5a3YxKDPL3wZGta-F2VrgOBU6VcXA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Meh... So what happens here is that the firmware is stuck while
> transmitting. The driver detects this and as a workaround, resets the
> firmware. The detection takes 10 seconds.
> The only way to understand what is going on here is to take the
> firmware from [1] and to run the steps to collect firmware debug data
> from [2]. I recommend you open a bug on bugzilla.
> Out of curiosity, did you try to work in DC mode (on battery, not
> connected to the power)? A user reported that it helped [3].

I followed the steps you suggested, and am now tracking the bug here:

https://bugzilla.kernel.org/show_bug.cgi?id=116191



