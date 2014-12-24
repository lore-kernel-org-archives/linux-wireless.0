Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:49680 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbaLXTE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 14:04:56 -0500
Date: Wed, 24 Dec 2014 21:04:52 +0200
From: Jouni Malinen <j@w1.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: hostapd and 11h support
Message-ID: <20141224190452.GA6933@w1.fi> (sfid-20141224_200459_126926_8CEAFC64)
References: <549A8827.3070703@broadcom.com>
 <20141224173227.GA1969@w1.fi>
 <549B05F0.9020704@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <549B05F0.9020704@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 24, 2014 at 07:29:04PM +0100, Arend van Spriel wrote:
> The firmware on the device *can* have CAC logic built-in. When it
> *is* built-in it is however disabled by default. Based on your
> feedback I will just detect firmware support, enable dfs in
> firmware, and signal DFS offload to hostapd. I would suggest
> introducing a new common capability flag for this instead of using a
> QCA vendor specific one. That would be odd ;-)

I see nothing odd in other drivers using the already defined QCA vendor
specific nl80211 command. Anyway, I have no issues with a new nl80211
capability flag added for this purpose. You'll probably have better
chances of getting that accepted with an upstream driver using it.

-- 
Jouni Malinen                                            PGP id EFC895FA
