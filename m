Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25924 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab2H0OQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 10:16:51 -0400
Message-ID: <503B8147.7030607@qca.qualcomm.com> (sfid-20120827_161654_677880_EC8C1A51)
Date: Mon, 27 Aug 2012 17:16:39 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath6kl: trivial cleanup
References: <1345818208-9129-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1345818208-9129-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2012 05:23 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> a minor cleanup in assigning the driver specific network type
> based on interface type.
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Thanks, applied to ath6kl.git. But I changed the title to:

ath6kl: trivial cleanup on interface type selection

Kalle
