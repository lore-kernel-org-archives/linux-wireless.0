Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms6.Sony.CO.JP ([211.125.136.204]:60080 "EHLO ms6.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbYE3HRo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 03:17:44 -0400
Received: from mta5.sony.co.jp (mta5.Sony.CO.JP [137.153.71.6])
 by ms6.sony.co.jp (R8/Sony) with ESMTP id m4U7Hfpk001238
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:17:41 +0900 (JST)
Received: from mta5.sony.co.jp (localhost [127.0.0.1])
 by mta5.sony.co.jp (R8/Sony) with ESMTP id m4U7Hf3K012535
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:17:41 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta5.sony.co.jp (R8/Sony) with ESMTP id m4U7HfpO012527
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:17:41 +0900 (JST)
Date: Fri, 30 May 2008 16:17:35 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] PS3: gelic: gelic updates
Cc: geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Message-Id: <20080530132951.4720.40F06B3A@sm.sony.co.jp> (sfid-20080530_091747_077158_F62939C8)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi,

Here are PS3 gelic wireless updates.

Patches 1 and 2 change the allocation way for the wireless bounce buffer.
#3 adds ESSID scanning support.

	#1 Allocate the bounce buffer dynamically
	#2 Kill the static bounce buffer
	#3 Add support for ESSID scan

They depend on the patch set which converts semaphores to mutexes
posted to netdev@vger by Daniel Walker <dwalker@mvista.com> on May 22.

Best regards.

-- 
Masakazu Mokuno

