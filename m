Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:52341 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbbDATrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 15:47:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix IBSS scanning on wmi-tlv and qca6174
References: <1427202843-9172-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 1 Apr 2015 22:47:03 +0300
In-Reply-To: <1427202843-9172-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 24 Mar 2015 13:14:03 +0000")
Message-ID: <87zj6rws08.fsf@kamboji.qca.qualcomm.com> (sfid-20150401_214717_945120_0BF77745)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> WLAN.RM.2.0-00073 firmware requires self-peer to
> be created prior to issuing scan command. Without
> this wmi-tlv with qca6174 firmware crashes after
> submitting a scan request.
>
> Creating the peer as soon as add_interface()
> shouldn't be a problem.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
