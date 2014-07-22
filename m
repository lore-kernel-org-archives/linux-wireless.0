Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:48694 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbaGVScH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 14:32:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: prevent endless pci rx loop
References: <1405687501-25917-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 22 Jul 2014 21:32:01 +0300
In-Reply-To: <1405687501-25917-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 18 Jul 2014 14:45:01 +0200")
Message-ID: <87vbqptfby.fsf@kamboji.qca.qualcomm.com> (sfid-20140722_203212_014591_A4E52EE0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It was possible to enter an endless loop while
> processing a single pci copy engine pipe. This
> could effectively render ath10k incapable of
> responding to any requests.
>
> An example case when this could happen is when
> firmware generates a lot of events, e.g. spectral
> scan phyerr via WMI.
>
> Reported-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
