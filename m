Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moh2-ve2.go2.pl ([193.17.41.200]:44556 "EHLO moh2-ve2.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab3J3LK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 07:10:29 -0400
Received: from moh2-ve2.go2.pl (unknown [10.0.0.200])
	by moh2-ve2.go2.pl (Postfix) with ESMTP id 62173B00E5A
	for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 12:10:24 +0100 (CET)
Received: from unknown (unknown [10.0.0.142])
	by moh2-ve2.go2.pl (Postfix) with SMTP
	for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 12:10:24 +0100 (CET)
Message-ID: <5270E925.6080200@o2.pl> (sfid-20131030_121033_251843_D7434A91)
Date: Wed, 30 Oct 2013 12:10:29 +0100
From: Piotr Kaczorek <kacz0r1984@o2.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Monitor mode stopped working after kernel upgrade
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update

I tried few more kernels (few longterm versions from kernel.org - 
3.2.52, 3.4.67, 3.9.11 and current stable 3.11.6).
On 3.4.67 monitor mode still works.

On version 3.9.11 and above it doesn't.

Unfortunately I wanted support for Ralink 5572 which works since ~3.10.

Regards,
Piotr

