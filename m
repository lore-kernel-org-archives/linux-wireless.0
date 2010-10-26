Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:57716 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075Ab0JZMsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 08:48:16 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o9QCm4Jo027935
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 07:48:16 -0500
Subject: Re: [PATCH 2/2] wl1271: Check interface state in op_* functions
From: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
To: "ext juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288092279-31272-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1288092279-31272-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1288092279-31272-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 15:42:11 +0300
Message-ID: <1288096931.17497.352.camel@tukatila-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-26 at 13:24 +0200, ext juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> Check the state of the interface on op_* function so we don't try to access
> the hardware in when its off.
> 
> The mac80211 may call these in some corner cases related, for instance, to
> the hardware recovery procedure. These accesses cause a kernel crash on at
> least some SDIO devices, because the bus is not properly claimed in that
> scenario.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Tested-by: Tuomas Katila <ext-tuomas.2.katila@nokia.com>

-Tuomas

