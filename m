Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56925 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbcEWUXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2016 16:23:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mwifiex: handle edmac vendor command
References: <1461945483-3239-1-git-send-email-akarwar@marvell.com>
	<cbd542a552db4d368a5b402307976494@SC-EXCH04.marvell.com>
Date: Mon, 23 May 2016 23:22:59 +0300
In-Reply-To: <cbd542a552db4d368a5b402307976494@SC-EXCH04.marvell.com>
	(Amitkumar Karwar's message of "Thu, 12 May 2016 15:39:29 +0000")
Message-ID: <87zirg8qxo.fsf@kamboji.qca.qualcomm.com> (sfid-20160523_222311_597112_3742FD0E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> Hi Kalle,
> 	
>> From: Amitkumar Karwar [mailto:akarwar@marvell.com]
>> Sent: Friday, April 29, 2016 9:28 PM
>> To: linux-wireless@vger.kernel.org
>> Cc: Jeff CF Chen; Amitkumar Karwar
>> Subject: [PATCH] mwifiex: handle edmac vendor command
>> 
>> From: chunfan chen <jeffc@marvell.com>
>> 
>> Userspace can configure edmac values through a custom vendor command.
>> They will be used by hardware for adaptivity.
>> 
>> Signed-off-by: chunfan chen <jeffc@marvell.com>
>> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

[deleted over 200 lines of unnecessary quotes]

> This patch seems to have deferred. We basically want a way to download
> a vendor specific configuration to our firmware. Do you have any
> suggestions on how can achieve this in better way?
>
> I can see below iw command suits our requirement.
>
> iw dev <devname> vendor send <oui> <subcmd> <filename|-|hex data>
>
> Please guide.

It was deferred because use of the nl80211 vendor interface (which I
don't think belong to upstream drivers). I'll take a look at this patch
in detail after the merge window.

-- 
Kalle Valo
