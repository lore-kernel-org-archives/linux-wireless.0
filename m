Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dub004-omc4s13.hotmail.com ([157.55.2.88]:57272 "EHLO
	DUB004-OMC4S13.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241AbbBWPXr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 10:23:47 -0500
Message-ID: <DUB128-W37C494FFAF5BDEE054C5D09C290@phx.gbl> (sfid-20150223_162353_624041_A6C535C9)
From: David Binderman <dcb314@hotmail.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: linux-4.0-rc1 bug report
Date: Mon, 23 Feb 2015 15:18:43 +0000
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

[linux-4.0-rc1/drivers/net/wireless/ath/wil6210/debugfs.c:634]: (error) Width 8 given in format string (no. 1) is larger than destination buffer 'cmd[8]', use %7s to prevent overflowing it.

This looks like an off-by-one error to me.

Suggest either make the buffer bigger, to contain all 8 characters,
or change the width to suit.

Regards

David Binderman

 		 	   		  