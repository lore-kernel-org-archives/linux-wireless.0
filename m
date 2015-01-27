Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:40676 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbA0NwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 08:52:04 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: add wmi-tlv debug event handling
References: <1420715897-18706-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 Jan 2015 15:51:53 +0200
In-Reply-To: <1420715897-18706-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 8 Jan 2015 12:18:15 +0100")
Message-ID: <87bnlkcow6.fsf@kamboji.qca.qualcomm.com> (sfid-20150127_145208_247008_AA29FF26)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> New wmi-tlv firmware will deliver debug messages
> via new events.
>
> Note: This may yield some (trivial) conflicts
> against my beacon/presp template patchset.
>
>
> Michal Kazior (2):
>   ath10k: implement diag data container event
>   ath10k: implement diag event

Thanks, applied to ath.git.

-- 
Kalle Valo
