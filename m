Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:14962 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaH2Fqw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 01:46:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add device/driver strings to tracepoints
References: <1409231135-16233-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 29 Aug 2014 08:46:46 +0300
In-Reply-To: <1409231135-16233-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 28 Aug 2014 15:05:35 +0200")
Message-ID: <877g1ru9tl.fsf@kamboji.qca.qualcomm.com> (sfid-20140829_074659_059842_439D0A31)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This makes it easier to log and debug via tracing
> with more than 1 ath10k device on a system.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

In ath-next-test I had a simple conflict in wmi.c. Please check my
conflict resolution:

https://github.com/kvalo/ath/commit/d4bcfa9487e0837fdaf01645ade15acbadc3873c

-- 
Kalle Valo
