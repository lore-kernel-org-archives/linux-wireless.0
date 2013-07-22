Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46307 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab3GVQ6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 12:58:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/2] MAINTAINERS: add ath10k
References: <20130722093113.26562.11543.stgit@localhost6.localdomain6>
	<20130722093220.26562.14270.stgit@localhost6.localdomain6>
	<1374504278.2061.35.camel@joe-AO722>
Date: Mon, 22 Jul 2013 19:58:11 +0300
In-Reply-To: <1374504278.2061.35.camel@joe-AO722> (Joe Perches's message of
	"Mon, 22 Jul 2013 07:44:38 -0700")
Message-ID: <87zjtewmzg.fsf@kamboji.qca.qualcomm.com> (sfid-20130722_185825_028120_620F5082)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Mon, 2013-07-22 at 12:32 +0300, Kalle Valo wrote:
>> I forgot to add an entry to MAINTAINERS when submitting the driver.
> []
>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>> +QUALCOMM ATHEROS ATH10K WIRELESS DRIVER
>
> It's odd to not find ATH6KL next to ATH10K.

I was wondering the same, but decided to put the entries in alphabetical
order still.

> Maybe it's time to rename all the ATH sections
> to make them QUALCOMM?

Maybe, but does it really matter? Changing the MAINTAINERS file just
creates unnecessary conficts for git merges.

-- 
Kalle Valo
