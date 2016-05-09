Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50923 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbcEIJuP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 05:50:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1azhpH-0004oZ-7X
	for linux-wireless@vger.kernel.org; Mon, 09 May 2016 11:50:07 +0200
Received: from gw.alumnux.com ([182.74.215.94])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2016 11:50:07 +0200
Received: from archisman001 by gw.alumnux.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2016 11:50:07 +0200
To: linux-wireless@vger.kernel.org
From: Archisman Maitra <archisman001@gmail.com>
Subject: Re: [PATCH 4/4] ath10k: Enable support for QCA9984
Date: Mon, 9 May 2016 09:46:40 +0000 (UTC)
Message-ID: <loom.20160509T113952-8@post.gmane.org> (sfid-20160509_115019_553539_A05D5F68)
References: <1461164356-9158-1-git-send-email-vthiagar@qti.qualcomm.com> <1461164356-9158-5-git-send-email-vthiagar@qti.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



The firmware crashes on applying this patch.. On examining the kernel OOPs, 
I have found out that that ath10k_bmi_execute in 
drivers/net/wireless/ath/ath10k/core.c when called goes in a loop until 
timeout occurs after which it eventually crashes. This is called from 
ath10k_core_get_board_id_from_otp in 
drivers/net/wireless/ath/ath10k/core.c . As per my understanding, the 
binaries of QCA99X0 that I have used for QCA9984 is not the correct one. 
Could you clarify? 
 

