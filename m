Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9755 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbbCDNlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 08:41:07 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: workaround qca6174 sta powersave issue
References: <1423830616-7516-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 4 Mar 2015 15:40:58 +0200
In-Reply-To: <1423830616-7516-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 13 Feb 2015 13:30:15 +0100")
Message-ID: <87h9u07udx.fsf@kamboji.qca.qualcomm.com> (sfid-20150304_144111_423179_36F2DC5B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> qca6184 WLAN.RM.2.0-00073 has a bug in sta
> powersave state machine and requires peer param to
> be poked to enable the powersave.
>
> Calling this unconditionally should be safe for
> other chips/firmwares.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, both patches applied.

-- 
Kalle Valo
