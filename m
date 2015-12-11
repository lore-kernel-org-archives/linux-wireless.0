Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57656 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbbLKJC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 04:02:29 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	chunfan chen <jeffc@marvell.com>
Subject: Re: [PATCH 5/6] mwifiex: add iw vendor command support
References: <1449238387-27396-1-git-send-email-akarwar@marvell.com>
	<1449238387-27396-5-git-send-email-akarwar@marvell.com>
Date: Fri, 11 Dec 2015 11:02:21 +0200
In-Reply-To: <1449238387-27396-5-git-send-email-akarwar@marvell.com>
	(Amitkumar Karwar's message of "Fri, 4 Dec 2015 06:13:06 -0800")
Message-ID: <87eget5peq.fsf@kamboji.qca.qualcomm.com> (sfid-20151211_100235_294218_E2A6E96D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> From: chunfan chen <jeffc@marvell.com>
>
> The patch allows user to
> 1. Enable turbo mode in firmware using
> following command.
> iw dev mlan0 vendor send 0x005043 0x00 0x01
>
> 2. Download configuration data to FW using
> following command
> iw dev mlan0 vendor send 0x005043 0x01 filename
>
> Signed-off-by: chunfan chen <jeffc@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Stuff like this gives me nightmares and I'm going to put this patch to
deferred state for now as I don't want to even think what to do. In the
mean time people can convince me should I take this or not.

-- 
Kalle Valo
