Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42712 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbbLJOHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 09:07:00 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Lin <dlin@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chor Teck Law" <ctlaw@marvell.com>, Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v7] Add new mac80211 driver mwlwifi.
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
	<1448018530.3141.25.camel@sipsolutions.net>
	<097ef0472294430d98940ad601a4aade@SC-EXCH02.marvell.com>
Date: Thu, 10 Dec 2015 16:06:52 +0200
In-Reply-To: <097ef0472294430d98940ad601a4aade@SC-EXCH02.marvell.com> (David
	Lin's message of "Thu, 26 Nov 2015 08:27:06 +0000")
Message-ID: <87vb8675z7.fsf@kamboji.qca.qualcomm.com> (sfid-20151210_150705_331712_77C804D7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Lin <dlin@marvell.com> writes:

>> > +#define MWL_DRV_NAME     KBUILD_MODNAME
>> > +#define MWL_DRV_VERSION	 "10.3.0.14"
>> 
>> versions like that are generally fairly useless since you don't update them for
>> every commit ...
>> 
>
> We still need version information for formal release.

Then use git commit ids for tracking the driver version. Using manual
version strings for drivers don't work, it has been tried multiple times
and they are always out of sync.

-- 
Kalle Valo
