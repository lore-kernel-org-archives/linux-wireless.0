Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:38947 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab0LUPYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 10:24:18 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.neratec.ch (Postfix) with ESMTP id 741E1860D1
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 16:15:07 +0100 (CET)
Received: from mail.neratec.ch ([127.0.0.1])
	by localhost (mail.neratec.ch [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q-yD0UpRflcK for <linux-wireless@vger.kernel.org>;
	Tue, 21 Dec 2010 16:15:06 +0100 (CET)
Received: from mail.neratec.ch (mail.neratec.ch [192.168.11.23])
	by mail.neratec.ch (Postfix) with ESMTP id E546B860D0
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 16:15:06 +0100 (CET)
Date: Tue, 21 Dec 2010 16:15:06 +0100 (CET)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Message-ID: <142800082.11106.1292944506791.JavaMail.root@idefix>
In-Reply-To: <372568220.11085.1292942671813.JavaMail.root@idefix>
Subject: [PATCH 0/4] DFS: radar pattern detector design proposal
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi DFS developers,

now that we are starting to think about the design for DFS functionality, this is how we started implementing a common radar pattern detector within mac80211 at our company.

It is a pure proof-of-concept and not meant to be used for other than testing.


More info available at [1].


Cheers
Zefir


[1] http://wireless.kernel.org/en/developers/DFS/DetectorDesignNt
