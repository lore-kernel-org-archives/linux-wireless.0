Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:35961 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZJTIGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 04:06:16 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id D1A063A00D
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 10:06:20 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FIGGYV5Ynmqq for <linux-wireless@vger.kernel.org>;
	Tue, 20 Oct 2009 10:06:20 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F95A1.dip0.t-ipconnect.de [217.95.149.161])
	by mx51.mymxserver.com (Postfix) with ESMTP id 8306A3A008
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 10:06:20 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 0AEFF1E0010
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 10:06:11 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Question about "txrate: current unicast bitrate to this station"
Date: Tue, 20 Oct 2009 10:05:57 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910201005.57862.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, this is the TX rate if the WLAN card is operating in AP mode, 
but it is really a RXRATE (despite the name) if the WLAN card is 
working in STATION mode?

-- 
http://www.holgerschurig.de
