Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16616 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2JUKFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 06:05:00 -0400
Cc: <ath6kl-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Set HT caps when an interface is added
References: <1350402738-6422-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Sun, 21 Oct 2012 12:58:43 +0300
In-Reply-To: <1350402738-6422-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Tue, 16 Oct 2012 21:22:18
	+0530")
Message-ID: <873918b0z0.fsf@qca.qualcomm.com> (sfid-20121021_120509_890992_F066994A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> Set HT capabilites when a vif is added (based on ht_supported
> advertized is 'true'). ath6kl_set_htcap
> seems to be called when an AP vif is added but not so in
> other vifs. Fix this.
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

This was found during code review, right? Or does it fix a real bug?

Kalle
