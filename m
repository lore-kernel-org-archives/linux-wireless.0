Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47151 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660AbcDSPqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 11:46:04 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"mohammed@codeaurora.org" <mohammed@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix return value for btcoex and peer stats
 debugfs
Date: Tue, 19 Apr 2016 15:46:00 +0000
Message-ID: <874maxk3f4.fsf@kamboji.qca.qualcomm.com> (sfid-20160419_174611_568221_7D87491E)
References: <1459870106-2694-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1459870106-2694-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Tue, 5 Apr 2016 20:58:26	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> Return value is incorrect for btcoex and peer stats debugfs
> 'write' entries if the user provides a value that matches with
> the already available debugfs entry, this results in the debugfs
> entry getting stuck and the operation has to be terminated manually.
> Fix this by returning the appropriate return 'count' as we do it for
> other debugfs entries like pktlog etc
>
> Fixes: cc61a1bbbc0e ("ath10k: enable debugfs provision to enable
> Peer Stats feature")
> Fixes: c28e6f06ff40 ("ath10k: fix sanity check on enabling btcoex via
> debugfs")
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Applied, thanks.

I removed the line wrapping from "Fixes:" lines.

-- 
Kalle Valo