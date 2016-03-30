Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34498 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbcC3MTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 08:19:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [V11,2/2] brcmfmac: add support for nl80211 BSS_SELECT feature
References: <56F65580.4060403@broadcom.com>
	<87pouhcz3a.fsf@kamboji.qca.qualcomm.com>
	<56FA40FD.3040609@broadcom.com>
Date: Wed, 30 Mar 2016 15:19:41 +0300
In-Reply-To: <56FA40FD.3040609@broadcom.com> (Arend Van Spriel's message of
	"Tue, 29 Mar 2016 10:46:53 +0200")
Message-ID: <87shz89mzm.fsf@kamboji.qca.qualcomm.com> (sfid-20160330_142000_544767_48877434)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

>> But please do remind about this, I seldomly check the "Awaiting
>> Upstream" queue so sometimes it might take way too long before I apply
>> the patch.
>
> So this is another way of saying the author should keep an eye on his
> patches when it ends up in this state or in general ;-) Noted.

Yeah, exactly :) Especially it's very helpful to send a note once the
dependency is in wireless-drivers-next, otherwise I need to manually
check and unsurprisingly I don't do it that often...

-- 
Kalle Valo
