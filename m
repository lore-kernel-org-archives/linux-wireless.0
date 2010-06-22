Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:32540 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab0FVMJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 08:09:17 -0400
Received: by fg-out-1718.google.com with SMTP id l26so10732fgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jun 2010 05:09:15 -0700 (PDT)
Message-ID: <4C20A7E8.7030208@googlemail.com>
Date: Tue, 22 Jun 2010 14:09:12 +0200
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Disable post-backoff
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello ath5k-list and linux-wireless-list!

I am sorry, if this is a double-post. I sent this message to the wrong
address before. I apologize.

For testing reasons I would like to disable backoff times in ath5k.

In the code of ath5k we have the macro AR5K_TXQ_FLAG_BACKOFF_DISABLE in
file linux-2.6.34/drivers/net/wireless/ath/ath5k/ath5k.h. It is issued
in the file linux-2.6.34/drivers/net/wireless/ath/ath5k/qcu.c in line 384.

How can this option be activated?

Kind regards, Dennis
