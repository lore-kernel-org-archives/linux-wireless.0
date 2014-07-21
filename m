Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:51032 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaGURjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 13:39:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <vh.nguyen@actiasodielec.fr>,
	<svens@stackframe.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT 1/2] ath10k: fix monitor start/stop sequences
References: <1405516873-26411-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 21 Jul 2014 20:39:26 +0300
In-Reply-To: <1405516873-26411-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 16 Jul 2014 15:21:12 +0200")
Message-ID: <87d2cyy5kh.fsf@kamboji.qca.qualcomm.com> (sfid-20140721_193936_039565_DCE8CA83)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Fix some cases where monitor start failure left
> the driver in a confused state.
>
> This also makes the monitor code simpler.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

>From a quick review looks good to me. Are you planning to submit this as
a proper patch at some point?

Did anyone test this?

-- 
Kalle Valo
