Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp126.iad.emailsrvr.com ([207.97.245.126]:43926 "EHLO
	smtp126.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbXHCAcA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 20:32:00 -0400
Message-ID: <46B27729.5030406@gentoo.org>
Date: Thu, 02 Aug 2007 20:30:33 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>,
	Jiri Benc <jbenc@suse.cz>, Ulrich Kunitz <kune@deine-taler.de>
Subject: mac80211 driver interface semantics
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There has been some recent confusion as to how monitor interfaces should 
operate, how multiple interfaces should be handled by drivers, and how 
MAC addresses should be handled.

Based on some recent discussions, and what bcm43xx does, I started 
writing some documentation:

http://www.linuxwireless.org/en/developers/mac80211/semantics

Discuss :)
I probably made some mistakes. Corrections are very welcome.

Thanks,
Daniel
