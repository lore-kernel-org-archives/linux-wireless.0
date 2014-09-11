Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:49686 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149AbaIKUoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 16:44:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: support firmware crash-by-assert
References: <20140910155928.30418.45160.stgit@potku.adurom.net>
Date: Thu, 11 Sep 2014 23:44:00 +0300
In-Reply-To: <20140910155928.30418.45160.stgit@potku.adurom.net> (Kalle Valo's
	message of "Wed, 10 Sep 2014 18:59:28 +0300")
Message-ID: <87vbot28hb.fsf@kamboji.qca.qualcomm.com> (sfid-20140911_224426_919576_31645FC4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Ben Greear <greearb@candelatech.com>
>
> 10.1 firmware does not have an official way to
> cause assert on purpose, but it can be done with
> carefully crafted WMI command.  This is a different
> kind of crash from the 'hard' crash, which is
> a bad memory dereference.
>
> Different crashes decode in different manners, so
> this will help the crash-report testing as well as
> offer better ways to test firmware failure and
> recovery.
>
> kvalo: move the wmi command creation to debug.c, modify
> the info print
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Thanks Ben, applied.

-- 
Kalle Valo
