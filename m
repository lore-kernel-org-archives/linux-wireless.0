Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-2.sys.kth.se ([130.237.32.160]:42331 "EHLO
	smtp-2.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbZJ2Nx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 09:53:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp-2.sys.kth.se (Postfix) with ESMTP id 2731B14E2A6
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2009 14:19:32 +0100 (CET)
Received: from smtp-2.sys.kth.se ([127.0.0.1])
	by localhost (smtp-2.sys.kth.se [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id v-3GzEy0T+Hx for <linux-wireless@vger.kernel.org>;
	Thu, 29 Oct 2009 14:19:26 +0100 (CET)
Received: from exhub01.ug.kth.se (exhub01.ug.kth.se [IPv6:2001:6b0:1:1200:b8e3:b9b9:e19a:3274])
	by smtp-2.sys.kth.se (Postfix) with ESMTP id 256BF14E32A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2009 14:19:26 +0100 (CET)
From: Dan Rosenqvist <danro@kth.se>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 29 Oct 2009 14:19:25 +0100
Subject: mesh support for rt73
Message-ID: <209743CECB91EB4F84169A51F300410D97BA47DBF4@MAIL02.ug.kth.se>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm currently trying to set up a small 802.11s mesh network. As I've come to understand there's no support for mesh networking at the moment for rt 73 based cards (using DWL-G122 C1).

Is it possible to implement the changes mentioned in http://linuxwireless.org/en/developers/Documentation/mac80211/API to support mesh networks for rt 73 as well? 
Is there someone out there currently working on this? Otherwise, how could I contribute to make this work?

Regards,
Dan