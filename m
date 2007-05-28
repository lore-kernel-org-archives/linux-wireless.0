Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:32880 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761338AbXE1JMo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2007 05:12:44 -0400
Received: from math.ut.ee (math.ut.ee [193.40.36.2])
	by smtp2.it.da.ut.ee (Postfix) with ESMTP id 109E04C037BB
	for <linux-wireless@vger.kernel.org>; Mon, 28 May 2007 11:45:26 +0300 (EEST)
Received: from localhost (localhost [127.0.0.1])
	by math.ut.ee (Postfix) with ESMTP id 07FFA6ADEB
	for <linux-wireless@vger.kernel.org>; Mon, 28 May 2007 11:45:26 +0300 (EEST)
Date: Mon, 28 May 2007 11:45:25 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: linux-wireless@vger.kernel.org
Subject: libertas 64-bit warning
Message-ID: <Pine.SOC.4.64.0705281143380.1596@math>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While compiling libertas on sparc64 for test:

  CC [M]  drivers/net/wireless/libertas/debugfs.o
drivers/net/wireless/libertas/debugfs.c: In function 'libertas_getscantable':
drivers/net/wireless/libertas/debugfs.c:92: warning: format '%08llx' expects type 'long long unsigned int', but argument 4 has type '__le64'
drivers/net/wireless/libertas/debugfs.c:92: warning: format '%08llx' expects type 'long long unsigned int', but argument 4 has type '__le64'

Looks like wrong format string specifier.

-- 
Meelis Roos (mroos@linux.ee)
