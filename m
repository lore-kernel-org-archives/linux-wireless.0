Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:57766 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2FSIHA (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Tue, 19 Jun 2012 04:07:00 -0400
Received: by bkcji2 with SMTP id ji2so4799249bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 01:06:40 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 Jun 2012 16:06:40 +0800
Message-ID: <CALx5=V--5TEC2J39xdJn1fxLbmgEXsWwxbAVaXMsw=Lk2WxKRg@mail.gmail.com> (sfid-20120619_100707_828876_19B6FC6A)
Subject: Atheros [168c 0034] can't enable wireless button LED.
From: Matt Chen <machen@suse.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi experts,

I tested the latest kernel v3.5-rc3 ath9k for the Atheros [168c 0034],
code name is Miami. I found no matter how I press the wifi button to
enable/disable the wifi, it doesn't work to me.
Even I found the rfkill status for this interface is not changing.

-- 
Thank you.
