Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14604 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992AbaDBHiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 03:38:04 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: remove not needed warning when peer unmap
References: <1396340628-4570-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Wed, 2 Apr 2014 10:37:58 +0300
In-Reply-To: <1396340628-4570-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 1 Apr 2014 10:23:48 +0200")
Message-ID: <87vbusqizt.fsf@kamboji.qca.qualcomm.com> (sfid-20140402_093809_885491_4F02A6C9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Remove not needed warning when get peer unmap
> event from the firmware. This is not critical
> message. Instead print this as a debug message.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

This one has a new checkpatch warning:

drivers/net/wireless/ath/ath10k/txrx.c:204: CHECK: Alignment should match open parenthesis

-- 
Kalle Valo
