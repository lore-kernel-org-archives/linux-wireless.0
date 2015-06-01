Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19417 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbFAHN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 03:13:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Marty Faltesek <mfaltesek@google.com>,
	Martin Faltesek <martin.faltesek@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: system hang with backports-20150511/20150525
References: <CAOiWkA_i8mSx_DtW-Z8mdSiqMZcUXJp0nwCrZGkEZDWBUb3cVg@mail.gmail.com>
	<CA+BoTQnfXGLSvbx+hLfi_2w90-LgC3Uba0ZcO+Pt7J3FcEE9wg@mail.gmail.com>
Date: Mon, 1 Jun 2015 10:13:20 +0300
In-Reply-To: <CA+BoTQnfXGLSvbx+hLfi_2w90-LgC3Uba0ZcO+Pt7J3FcEE9wg@mail.gmail.com>
	(Michal Kazior's message of "Mon, 1 Jun 2015 08:36:06 +0200")
Message-ID: <87vbf7vr3j.fsf@kamboji.qca.qualcomm.com> (sfid-20150601_091329_422420_BD5B93DF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> +ath10k list
>
> On 1 June 2015 at 03:37, Marty Faltesek <mfaltesek@google.com> wrote:
>> Starting with backports-20150511, and continuing with
>> backports-20150525, we see frequent system hangs. backports-20150424
>> had no issue.
>
> I don't see such binary releases on
> https://backports.wiki.kernel.org/index.php/Main_Page
> Hence I don't know what kernel you've backported the drivers from and
> I can't compare anything.
>
> Can you provide more details, please?

I suspect it's from here:

https://www.kernel.org/pub/linux/kernel/projects/backports/2015/05/25/

The backports project pages are a bit confusing and that location is
hard to find.

-- 
Kalle Valo
