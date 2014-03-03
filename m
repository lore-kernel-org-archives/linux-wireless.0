Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailsrv0.aau.at ([143.205.180.48]:50917 "EHLO
	mailsrv.uni-klu.ac.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754481AbaCCKKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 05:10:05 -0500
Received: from mailsrv.uni-klu.ac.at (localhost [127.0.0.1])
	by mailsrv.uni-klu.ac.at (Postfix) with ESMTP id CB94A161515
	for <linux-wireless@vger.kernel.org>; Mon,  3 Mar 2014 11:03:37 +0100 (CET)
Received: from [143.205.116.97] (zeno.nes.aau.at [143.205.116.97])
	by mailsrv.uni-klu.ac.at (Postfix) with ESMTPSA id BFF41160EFF
	for <linux-wireless@vger.kernel.org>; Mon,  3 Mar 2014 11:03:37 +0100 (CET)
Message-ID: <5314538C.40705@aau.at> (sfid-20140303_111338_897718_8EB249B5)
Date: Mon, 03 Mar 2014 11:03:56 +0100
From: Severin Kacianka <severin.kacianka@aau.at>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Wireless Bandwidth Estimation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am currently looking a bit into the subject of estimating the 
available bandwidth on a wireless link and I wanted to ask if there are 
any tool or kernel parameters out there that might already do this. I am 
aware that there are many papers on this subject (just take a look at 
google scholar [1]), but none seem to offer a 'reliable' solution. The 
best working tool I could find so far was wbest[2], but its results are 
very jumpy.

I do not look for a tool to *measure* the available bandwidth (iperf 
does that just fine), I would ideally like to get an estimation without 
sending any data over the link (or at least only a few packets).

As an example think of video streaming: A video stream might take up 
most of the bandwidth and thus you would like to avoid creating 
additional measurement traffic. However - if the wireless link degraded 
(because the client might move) what would be the best way to 'sense' 
this degradation as early as possible and react to it (by e.g. reducing 
the video bandwidth).

Thank you for your time,
Severin

[1] http://scholar.google.at/scholar?q=wireless+bandwidth+estimation
[2] http://perform.wpi.edu/downloads/wbest/
