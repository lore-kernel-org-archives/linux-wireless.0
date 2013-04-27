Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:40857 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab3D0T1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 15:27:32 -0400
Received: from stuffed.shaftnet.org (localhost [127.0.0.1])
	by stuffed.shaftnet.org (8.14.5/8.14.5) with ESMTP id r3RJRUCr012423
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sat, 27 Apr 2013 15:27:30 -0400
Received: (from pizza@localhost)
	by stuffed.shaftnet.org (8.14.5/8.14.5/Submit) id r3RJRTOe012422
	for linux-wireless@vger.kernel.org; Sat, 27 Apr 2013 15:27:29 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ST-E CW1200 driver (v6)
Date: Sat, 27 Apr 2013 15:27:13 -0400
Message-Id: <1367090847-11937-1-git-send-email-pizza@shaftnet.org> (sfid-20130427_212737_941347_EC477174)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'd love to see this finally committed upstream.  There are no known 
bugs in the code, and it handles everything I (and other testers I've 
been working with) have thrown at it.

Changes from the last patch series (v5):
 * Updated contact info for original author (Dmitry Tarnyagin)
 * Better documented the DPLL constants
 * Fixed more checkpatch warnings
 * Better logging in scan and bss loss state machines
 * BSS loss mitigation reimplemented (differently) due to FW bugginess
 * Reworked locking in the join code to handle rare corner cases

