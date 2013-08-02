Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:49244 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab3HBGjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 02:39:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/5] ath10k: fixes
References: <1375260915-22500-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 2 Aug 2013 09:38:57 +0300
In-Reply-To: <1375260915-22500-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 31 Jul 2013 10:55:10 +0200")
Message-ID: <87k3k4ppfi.fsf@kamboji.qca.qualcomm.com> (sfid-20130802_083909_186578_C267EB6A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This is a batch up of a few fixes for ath10k
> driver I had in my queue for some time now.
>
>
> Michal Kazior (5):
>   ath10k: prevent using invalid ringbuffer indexes
>   ath10k: make sure to use passive scan when n_ssids is 0
>   ath10k: advertise more conservative intf combinations
>   ath10k: zero arvif memory on add_interface()
>   ath10k: fix failpath in MSI-X setup

All applied, thanks.

-- 
Kalle Valo
