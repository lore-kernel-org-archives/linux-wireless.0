Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60687 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab2EQGPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 02:15:07 -0400
Message-ID: <4FB49765.2080105@qca.qualcomm.com> (sfid-20120517_081514_316618_0B60A920)
Date: Thu, 17 May 2012 09:15:01 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: issue wmi disconnect after notifying cfg80211
References: <1337200873-3698-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1337200873-3698-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2012 11:41 PM, Thomas Pedersen wrote:
> ath6kl would issue a wmi disconnect command in response to a remote
> disconnect and return early without notifying cfg80211, only sending a
> cfg80211_disconnected (with reason code always 3) in response to the
> second disconnect firmware event.
> 
> Pass the right reason code to cfg80211 on the first disconnect instead.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied with the extra description about the actual bug this is
fixing.

Kalle
