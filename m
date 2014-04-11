Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16862 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaDKFlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 01:41:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: double check bmi xfer pointers
References: <53461A8A.4030209@candelatech.com>
	<1397124355-6321-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 11 Apr 2014 08:40:56 +0300
In-Reply-To: <1397124355-6321-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 10 Apr 2014 12:05:55 +0200")
Message-ID: <8738hkh193.fsf@kamboji.qca.qualcomm.com> (sfid-20140411_074140_482821_68C9DF11)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If for some reason copy engine ring buffer became
> corrupt ath10k could crash the machine due to
> invalid pointer dereference. It's very unlikely
> but devices can never be fully trusted so verify
> if the bmi xfer pointer read back from copy engine
> matches the original pointer.

The big question is why does this happen? Does this happen only with
Ben's firmware or is it a more generic problem?

-- 
Kalle Valo
