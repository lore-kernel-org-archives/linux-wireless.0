Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:47712 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab2A3N33 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 08:29:29 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/12] wl12xx: update fw api
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
Date: Mon, 30 Jan 2012 15:29:27 +0200
In-Reply-To: <1327924857-1250-1-git-send-email-eliad@wizery.com> (Eliad
	Peller's message of "Mon, 30 Jan 2012 14:00:45 +0200")
Message-ID: <87fwexco94.fsf@purkki.adurom.net> (sfid-20120130_142933_239662_A7FE56AC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eliad Peller <eliad@wizery.com> writes:

> The fw api was changed in the latest FWs (6.3.5.0.95 for wl127x
> and 7.3.5.0.95 for wl128x).
>
> Along with some small adjustments, the main changes
> inroduced by this patheset are configuring the
> templates per-role, and moving to IEEE80211_HW_SUPPORTS_DYNAMIC_PS
> mode.

I didn't look so carefully, but doesn't this break bisect? I mean if you
change the firmware api in small patches wl12xx can't work properly
until all patches are applied, right?

I would say that a huge patch doing all the necessary changes in one go
is better, even it's ugly.

-- 
Kalle Valo
