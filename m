Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([86.59.21.13]:47442 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab3DWPtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 11:49:42 -0400
Message-ID: <5176ABB1.2070506@einfach.org> (sfid-20130423_175009_358738_46C8679E)
Date: Tue, 23 Apr 2013 16:41:37 +0100
From: Bruno Randolf <br1@einfach.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, frankyl@broadcom.com,
	arend@broadcom.com, meuleman@broadcom.com, brudley@broadcom.com,
	brcm80211-dev-list@broadcom.com
Subject: Broadcom brcmfmac vs bcmdhd on Android
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I know this is the Linux kernel wireless list, and not Android, but due 
to the lack of better places, I'm going to ask here...

I am trying to make IBSS mode work on Android. As I'm finding problems 
with "bcmdhd", I am wondering if using the "brcmfmac" under Android 
would be the better way to go?

I succeeded to compile brcmfmac from recent compat-drivers against the 
"tuna" (Galaxy Nexus) kernel, the modules load, but no device is 
recognized. Has anyone succeeded doing this? Is there any chance it can 
work?

Also I'm wondering what is the relation between the "bcmdhd" driver on 
Android and "brcmfmac" in the standard Linux kernel. Is there any 
official maintainer of "bcmdhd", any place where to submit patches? Will 
"bcmdhd" and "brcmfmac" merge eventually?

Thanks for any hints,
bruno
