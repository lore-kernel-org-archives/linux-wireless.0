Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1286 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1I1ROx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 13:14:53 -0400
Message-ID: <4E834DB1.40505@qca.qualcomm.com> (sfid-20110928_191457_161813_E4571C26)
Date: Wed, 28 Sep 2011 19:39:13 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: silence "invalid rate" warning
References: <20110927203328.20742.30194.stgit@localhost6.localdomain6>
In-Reply-To: <20110927203328.20742.30194.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2011 11:33 PM, Kalle Valo wrote:
> For some reason firmware is sending invalid rates when we try to
> query current bitrate from ath6kl_get_station() and a warning is issued:
> 
> [ 3810.415720] ath6kl: invalid rate: 1935633515
> [ 3811.105493] ath6kl: invalid rate: 1935633515
> [ 3811.556063] ath6kl: invalid rate: 1935633515
> 
> As the warning happens way too often, convert the warning to a debug
> message once we have a proper fix. But to make it easy to follow
> how often the problem appears, add a debugfs to print
> various statistics about workarounds and make this issue the first WAR.

Applied.

Kalle
