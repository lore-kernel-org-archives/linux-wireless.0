Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52421 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbcDDOye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 10:54:34 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"mohammed@codeaurora.org" <mohammed@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] ath10k: Enable debugfs provision to enable Peer
 Stats feature
Date: Mon, 4 Apr 2016 14:54:26 +0000
Message-ID: <878u0te867.fsf@kamboji.qca.qualcomm.com> (sfid-20160404_165438_432890_7F9A1E24)
References: <1458132214-4896-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1458132214-4896-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Wed, 16 Mar 2016 18:13:32	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> Provide a debugfs entry to enable/ disable Peer Stats feature.
> Peer Stats feature is for developers/users who are more interested
> in studying in Rx/Tx stats with multiple clients connected, hence
> disable this by default. Enabling this feature by default results
> in unneccessary processing of Peer Stats event for every 500ms
> and updating peer_stats list (allocating memory) and cleaning it up
> ifexceeds the higher limit and this can be an unnecessary overhead
> during long run stress testing.
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

All three applied, thanks.

-- 
Kalle Valo