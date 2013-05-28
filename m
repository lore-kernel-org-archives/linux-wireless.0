Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2531 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933668Ab3E1Iv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 04:51:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <linux-wireless@vger.kernel.org>,
	"John W . Linville" <linville@tuxdriver.com>,
	<ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2] wireless: ath6kl: re-use native helper to parse MAC
References: <1366896682-2023-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1369730853.29283.222.camel@smile>
Date: Tue, 28 May 2013 11:51:20 +0300
In-Reply-To: <1369730853.29283.222.camel@smile> (Andy Shevchenko's message of
	"Tue, 28 May 2013 11:47:33 +0300")
Message-ID: <87wqqjfpx3.fsf@kamboji.qca.qualcomm.com> (sfid-20130528_105130_304179_56C837F7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:

> On Thu, 2013-04-25 at 16:31 +0300, Andy Shevchenko wrote: 
>> There is native mac_pton() function which helps to parse MAC.
>> 
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[...]

>
> John, do you have any comment on this one?

ath6kl patches go through my tree. Sorry for not being able to look at
your patch yet as I have been very busy with something else, will do
that soon.

-- 
Kalle Valo
