Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36560 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbcGMHy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 03:54:57 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	torvalds@linux-foundation.org,
	"Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
	linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2016-07-11
References: <1468233921.25088.107.camel@coelho.fi>
Date: Wed, 13 Jul 2016 10:54:41 +0300
In-Reply-To: <1468233921.25088.107.camel@coelho.fi> (Luca Coelho's message of
	"Mon, 11 Jul 2016 13:45:21 +0300")
Message-ID: <87mvlmynum.fsf@kamboji.qca.qualcomm.com> (sfid-20160713_095500_941300_242B1E30)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> This is a fix for a warning that was spotted by Linus.  We already have
> this patch queued in -next, but it should have gone to -fixes.  I hope
> it is still possible to send it for 4.7.  And it shouldn't be a problem
> to have it in both, right? I guess git merge would take care of that.

Like we discussed privately, even if iwlwifi was printing warnings the
connection was still working for Linus so this is not critical enough
for 4.7 so late in the cycle. So let's drop this and the fix can go to
4.8 as planned.

-- 
Kalle Valo
