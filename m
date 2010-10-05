Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64907 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894Ab0JELTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 07:19:01 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o95BIcRF029763
	for <linux-wireless@vger.kernel.org>; Tue, 5 Oct 2010 14:18:58 +0300
Subject: Re: [PATCH 1/2] wl1271: Indicate disconnection on hardware failure
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285843408-6726-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1285843408-6726-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 14:18:31 +0300
Message-ID: <1286277511.15401.9.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 12:43 +0200, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> In the event of a hardware failure, reconfiguring a live connection back
> with the wl1271 chip does not work as expected. The chip has management
> features which require setting up the association from scratch to work
> correctly. To ensure this is done every time, in managed mode, when associated,
> indicate connection loss to the mac80211 before asking to reconfigure the
> hardware.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Thank you.  Applied the series to wl12xx/master.

-- 
Cheers,
Luca.

