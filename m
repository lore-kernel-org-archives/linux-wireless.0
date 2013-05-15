Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:38448 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab3EOPSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 11:18:14 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <ath10k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 02/29] ath10k: add bmi.h
References: <20130515143356.4492.43033.stgit@localhost6.localdomain6>
	<20130515144254.4492.14914.stgit@localhost6.localdomain6>
	<1368630093.20897.8.camel@jlt4.sipsolutions.net>
Date: Wed, 15 May 2013 18:17:53 +0300
In-Reply-To: <1368630093.20897.8.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Wed, 15 May 2013 17:01:33 +0200")
Message-ID: <871u98p90e.fsf@kamboji.qca.qualcomm.com> (sfid-20130515_171821_545327_754FAC05)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2013-05-15 at 17:42 +0300, Kalle Valo wrote:
>
>> +/*
>> + * Bootloader Messaging Interface (BMI)
>
> This looks exactly like ath6kl, but is it? Seems it might have potential
> for sharing the code.

Somewhere deep down ath10k and ath6kl have common history, but the
firmware engineers have made so many changes everywhere that IMHO trying
to share code is not really worth it.

-- 
Kalle Valo
