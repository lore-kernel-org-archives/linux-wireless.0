Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45912 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1HNJ3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 05:29:43 -0400
Message-ID: <4E479582.6070008@qca.qualcomm.com> (sfid-20110814_112954_413233_0E51468A)
Date: Sun, 14 Aug 2011 12:29:38 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Use cfg80211_inform_bss instead of cfg80211_inform_bss_frame
References: <20110810213249.GA7328@jouni.qca.qualcomm.com>
In-Reply-To: <20110810213249.GA7328@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2011 12:32 AM, Jouni Malinen wrote:
> There is no point in generating a bogus Beacon frame for
> cfg80211_inform_bss_frame when cfg80211_inform_bss can be used
> instead.

Thanks, applied to ath6kl tree.

Kalle
