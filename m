Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:3836 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaC1Hlo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 03:41:44 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: unify warning messages in mac.c
References: <1395673555-24848-1-git-send-email-kvalo@qca.qualcomm.com>
Date: Fri, 28 Mar 2014 09:41:39 +0200
In-Reply-To: <1395673555-24848-1-git-send-email-kvalo@qca.qualcomm.com> (Kalle
	Valo's message of "Mon, 24 Mar 2014 17:05:55 +0200")
Message-ID: <877g7eydl8.fsf@kamboji.qca.qualcomm.com> (sfid-20140328_084157_918344_7DBD7796)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Currently there are different styles used for warning messages, unify them to
> look similar. The style basically is:
>
> 1) start with a verb (if possible)
>
> 2) lower case letters
>
> 3) use plain english as much as possible
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

-- 
Kalle Valo
