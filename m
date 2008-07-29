Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:33101 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238AbYG2Emd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 00:42:33 -0400
Message-ID: <488E9FB8.3080804@lwfinger.net> (sfid-20080729_064237_118913_3885DFC1)
Date: Mon, 28 Jul 2008 23:42:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Please do not pull 2.6.27-rc1 into wireless-testing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

As stated in the subject, please do not update wireless-testing with 2.6.27-rc1, 
at least for a while. In the thread that starts at 
http://thread.gmane.org/gmane.linux.kernel.wireless.general/18423, I found that 
commit 175f9c1bba9b825d2 breaks wireless, at least for b43. Until that is fixed, 
I think wireless-testing should remain at 2.6.26.

Larry

