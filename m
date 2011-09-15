Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44598 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933850Ab1IONhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 09:37:45 -0400
Message-ID: <4E71FFA5.7010605@qca.qualcomm.com> (sfid-20110915_153748_987672_B104D065)
Date: Thu, 15 Sep 2011 16:37:41 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/9] ath6kl: query device tree for firmware board-id
References: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
In-Reply-To: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/2011 02:12 PM, Kalle Valo wrote:
> From: Sam Leffler <sleffler@chromium.org>
> 
> When no default board data file is present query the device tree for a
> board-id setting to identify the board data to use.  If the FDT lacks the
> necesary info fall back to the previous behaviour of using a compile-time
> board filename.

All nine patches applied.

Kalle
