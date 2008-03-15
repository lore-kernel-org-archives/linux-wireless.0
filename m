Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:46671 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752043AbYCOSDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2008 14:03:12 -0400
Date: Sat, 15 Mar 2008 19:01:21 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>
Subject: [PATCH] [RFT] b43legacy: fix bcm4303 crash
Message-ID: <20080315190121.70edbfcd@morte> (sfid-20080315_180322_259738_23BEB717)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should fix an hard crash which happened upon driver loading on bcm4303
rev. 2 devices. The bug was originally reported here:
https://bugzilla.redhat.com/show_bug.cgi?id=384981.
Please test.

This won't make bcm4303 rev. 2 devices working anyway, there still are some
issues with initial values which I'm trying to fix.


-- 
Ciao
Stefano
