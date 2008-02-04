Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout3.cns.ohiou.edu ([132.235.51.106]:41896 "EHLO
	smtpout3.cns.ohiou.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbYBDV44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 16:56:56 -0500
Received: from [132.235.16.10] (che004.ent.ohiou.edu [132.235.16.10] (may be forged))
	(authenticated bits=0)
	by oak.cats.ohiou.edu (8.13.1/8.13.1) with ESMTP id m14LkPoZ2073727
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 4 Feb 2008 16:46:26 -0500 (EST)
Message-ID: <47A787B3.8080301@ohio.edu> (sfid-20080204_215710_479695_9518FAFA)
Date: Mon, 04 Feb 2008 16:46:27 -0500
From: Stan Vernier <sv193702@ohio.edu>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: zd1211rw 802.11a?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm looking at the ZyXEL AG-225H wireless USB adapter specifically 
because of 802.11a.  According to the website, the driver currently 
doesn't support "A", but I did find the patch someone created at:

http://sourceforge.net/mailarchive/message.php?msg_id=8670543.post%40talk.nabble.com

He mentions that some things don't work, and I'm wonder what this 
exactly entails.  It'll be used in an situation where there might be 30 
networks to connect, and we just need to be able to connect to ours at 
the 5GHz frequency.  Will the patch work?
