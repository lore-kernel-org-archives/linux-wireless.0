Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:44508 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbbA0Rmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 12:42:37 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Avinash Patil <patila@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stable <stable@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mwifiex: set netif carrier off in ndo_open
References: <1421663076-32291-1-git-send-email-patila@marvell.com>
	<1422360747.20608.5.camel@pe-lt950>
Date: Tue, 27 Jan 2015 19:42:30 +0200
In-Reply-To: <1422360747.20608.5.camel@pe-lt950> (Avinash Patil's message of
	"Tue, 27 Jan 2015 17:42:27 +0530")
Message-ID: <871tmgaznd.fsf@kamboji.qca.qualcomm.com> (sfid-20150127_184242_048841_147BB34E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avinash Patil <patila@marvell.com> writes:

> On Mon, 2015-01-19 at 02:24 -0800, Avinash Patil wrote:
>> From: Johannes Berg <johannes@sipsolutions.net>
>> 
>> This patch adds fix to set carrier state off during ndo_open.
>> Carrier should be set to ON when device is ready to send data.
>> In case of station/adhoc interface device is able to transfer
>> data after successful association/join operation.
>> For AP this would be after bss_active event.
>> 
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> Signed-off-by: Avinash Patil <patila@marvell.com>

[...]

> I do not see this patch in master branch as well as in patchworks
> pending patchlist. Is this one also dropped? Do you want me to resend
> this as well while I am sending rebased DFS patches?

I had accidentally marked this patch as "Not Applicable" in patchwork,
sorry about that. Good thing that you noticed. I have applied the patch
now.

-- 
Kalle Valo
