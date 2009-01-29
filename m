Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:58107 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZA2TrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 14:47:01 -0500
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: "linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Cancel the dynamic ps timer in ioctl_siwpower.
References: <20090127135628.GA32059@myhost.users.atheros.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 29 Jan 2009 21:46:43 +0200
In-Reply-To: <20090127135628.GA32059@myhost.users.atheros.com> (ext Vivek Natarajan's message of "Tue\, 27 Jan 2009 14\:56\:28 +0100")
Message-ID: <87hc3hopy4.fsf@nokia.com> (sfid-20090129_204709_819401_7890CF49)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> If the dynamic power save timer has been started before the power save
> is disabled using iwconfig, we fail to cancel the timer. Hence cancel it
> while disabling power save.
>
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>

Even though John already applied this:

Reviewed-by: Kalle Valo <kalle.valo@nokia.com>

-- 
Kalle Valo
