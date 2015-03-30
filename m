Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:12321 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbbC3L7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 07:59:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: clear htt.freq
References: <1427363827-24125-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 30 Mar 2015 14:59:21 +0300
In-Reply-To: <1427363827-24125-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 26 Mar 2015 09:57:07 +0000")
Message-ID: <878uee66hy.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_135935_528291_EA29716B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If htt.freq isn't cleared and contains garbage fw
> may discard tx packets. Prevent this from
> happening by clearing htt.freq properly.
>
> Possible manifestation of the problem could be not
> being able to send auth request/response frames on
> firmware with HTT >= 3.4 (when freq param was
> introduced), e.g. on qca6174.
>
> Fixes: 8d6d36243610 ("ath10k: fix offchan reliability")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
