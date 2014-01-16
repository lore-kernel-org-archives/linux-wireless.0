Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:16917 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbaAPKza (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 05:55:30 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.neratec.com (Postfix) with ESMTP id 908DD981FFB
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 11:55:28 +0100 (CET)
Received: from mail.neratec.com ([127.0.0.1])
	by localhost (mail.neratec.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id aGqCYpQwsslQ for <linux-wireless@vger.kernel.org>;
	Thu, 16 Jan 2014 11:55:28 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mail.neratec.com (Postfix) with ESMTP id 29EC6982000
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 11:55:28 +0100 (CET)
Received: from mail.neratec.com ([127.0.0.1])
	by localhost (mail.neratec.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lceKNZ0WQNr4 for <linux-wireless@vger.kernel.org>;
	Thu, 16 Jan 2014 11:55:28 +0100 (CET)
Received: from [192.168.11.133] (CHB500181.neratec.local [192.168.11.133])
	by mail.neratec.com (Postfix) with ESMTPSA id 0EE6D981FFA
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 11:55:28 +0100 (CET)
Message-ID: <52D7B9C6.30908@neratec.com> (sfid-20140116_115534_243752_B207070C)
Date: Thu, 16 Jan 2014 11:51:50 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: compat-drivers and tracing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Has anyone been succesfull with trace-cmd with latest backports? It 
seems I can trace mac80211 which came with the kernel
but as soon as I install compat I cannot record any events. Trace-cmd 
report says always that there are no samples.
All debugfs entries are same and I can see event lists, enabled flags, 
etc. Even strace of trace-cmd are same for both cases.

I am using 3.12.8 mainline kernel from ubuntu ppa.

Does it have anything to do with module signing/tainting?

Wojtek
