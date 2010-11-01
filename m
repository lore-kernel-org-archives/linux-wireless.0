Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:58263 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab0KAK21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 06:28:27 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.neratec.ch (Postfix) with ESMTP id B0EFE860D2
	for <linux-wireless@vger.kernel.org>; Mon,  1 Nov 2010 11:18:22 +0100 (CET)
Date: Mon, 1 Nov 2010 11:18:21 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-ID: <17252874.311288606699683.JavaMail.wlan@CHBU500181>
In-Reply-To: <11935378.291288606405977.JavaMail.wlan@CHBU500181>
Subject: DFS implementation in mac80211
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
  Our company has started implementation of Dynamic Frequency Selection in current linux wireless drivers. We have got basic radar detection part working. It has been tested with software based pulse simulator.

The question is on how to integrate it with mac80211. Pulse detection has to be done deep in specific driver but decision making can be shifted to either mac80211 or higher into user space. Current ETSI specification allows up to 1 second time for changing channel so it doesn't need to be real time.
Has anyone put already some thoughts on where to implement available channel list management, radar table handling, etc. and what would be the interface?
 
Br,
Wojciech Dubowik

-- 
Wojciech Dubowik
Senior Software Engineer
Neratec Solutions AG
Rosswiesstr. 29, CH-8608 Bubikon, Switzerland
Tel: +41 55 253 2096 (office)
Fax: +41 55 253 2070
wojciech.dubowik@neratec.com
http://www.neratec.com
