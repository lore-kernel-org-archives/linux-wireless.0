Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38106 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933686AbcFTUej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 16:34:39 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: Support 4.9Ghz channels on AR9580 adapter.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1463092857-18503-1-git-send-email-greearb@candelatech.com>
To: Ben Greear <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Ben Greear" <greearb@candelatech.com>
Message-ID: <300e3070916441609ff73ea8e06ddb77@euamsexm01a.eu.qualcomm.com> (sfid-20160620_223527_017608_89E813C0)
Date: Mon, 20 Jun 2016 22:34:31 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> NOTE:  These channels must not be used in most regulatory
> domains unless you have a license from the FCC or similar!
> 
> A proper regulatory database is also required to actually use
> these channels.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>

I feel that the license is a problem and this doesn't belong to the kernel.
The patch has been dropped.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9086491/

