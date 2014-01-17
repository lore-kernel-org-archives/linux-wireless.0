Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv01.mrvanes.com ([94.103.150.236]:45548 "EHLO
	zimbra.mrvanes.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaAQNUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 08:20:55 -0500
Received: from localhost (localhost [127.0.0.1])
	by zimbra.mrvanes.com (Postfix) with ESMTP id ED29A402DE
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 14:12:33 +0100 (CET)
Received: from zimbra.mrvanes.com ([127.0.0.1])
	by localhost (zimbra.mrvanes.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id wFf-BNMJDQrR for <linux-wireless@vger.kernel.org>;
	Fri, 17 Jan 2014 14:12:18 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.mrvanes.com (Postfix) with ESMTP id BADDB42533
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 14:12:18 +0100 (CET)
Received: from zimbra.mrvanes.com ([127.0.0.1])
	by localhost (zimbra.mrvanes.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 19vQc9F1dS-Y for <linux-wireless@vger.kernel.org>;
	Fri, 17 Jan 2014 14:12:18 +0100 (CET)
Received: from minivanes.localnet (82-171-229-100.ip.telfort.nl [82.171.229.100])
	by zimbra.mrvanes.com (Postfix) with ESMTPSA id 956D1402DE
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 14:12:18 +0100 (CET)
From: Martin van Es <martin@mrvanes.com>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi + bluetooth mouse and legacy boot Dell XPS13
Date: Fri, 17 Jan 2014 14:12:18 +0100
Message-ID: <4562545.5AEVROSYYf@minivanes> (sfid-20140117_142059_616888_ED341DDC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm having major problems keeping my wireless connection up and running, 
together with bluetooth mouse on my Dell XPS13 (L322X, full-HD version).

I'm seeing regular firmware and hardware resets. I'm on kernel 3.12.7 and 
firmware loaded is 18.168.6.1. Hardware is Intel Corporation Centrino 
Advanced-N 6235 (rev 24). Wireless network is 802.11b/g, WPA2.

I've tried all possible combinations of module parameters without succes.

Last thing that comes to my mind is my legacy BIOS. Could anyone on this list 
either confirm or deny that instead booting the laptop in UEFI might help 
resolve the problems? Is anyone using this laptop with wifi and bluetooth 
mouse either using legacy or UEFI BIOS?

I'm asking because switching from legacy to UEFI seems to be a bit daunting, 
not in the least because the live CD's I tried have many problems recognising 
either the display adapter on recent kernels (ubuntu 13.10 boot CD black 
screen) or backlight seems to be broken (again) on 3.13.rc, using ubuntu 14.04 
boot CD).


Best regards,
Martin van Es
