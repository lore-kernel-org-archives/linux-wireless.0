Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.iisc.ernet.in ([203.200.35.70]:46467 "EHLO
	relay.iisc.ernet.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab0IOGlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 02:41:31 -0400
Received: from ece.iisc.ernet.in (www.ece.iisc.ernet.in [10.32.1.10])
	by relay.iisc.ernet.in (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id o8F6OwwN013420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 11:54:58 +0530
Received: from ece.iisc.ernet.in (localhost [127.0.0.1])
	by ece.iisc.ernet.in (8.13.6/8.13.6/SuSE Linux 0.8) with ESMTP id o8F6UmH2026293
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 12:00:48 +0530
From: Ani Rashmi Porwal <ani@ece.iisc.ernet.in>
Message-ID: <f3fb98ea99e89f199b281abadd823ebb.squirrel@www.ece.iisc.ernet.in>
Date: Wed, 15 Sep 2010 12:00:48 +0530
Subject: Channel Load measurement
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have started implementing 802.11k and looking at various measurements
that this standard defines. There is this channel load parameter I am
trying to figure out how to obtain.
The standard  defines channel load as the percentage of time the STA
sensed the medium to be busy as initiated by carrier sense mechanism. I
went through the wireless drivers of various chipsets, I am not able to
get this piece of information at all.  Can you help me in this ?

Ani

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

