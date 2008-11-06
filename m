Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:48045 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbYKFPxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 10:53:08 -0500
Message-ID: <491312D2.5050008@lwfinger.net> (sfid-20081106_165312_290064_BD13A473)
Date: Thu, 06 Nov 2008 07:52:50 -0800
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH/RFT] b43legacy: implement short slot and basic rate handling
References: <1225981091.3619.227.camel@johannes.berg>
In-Reply-To: <1225981091.3619.227.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Subject: b43legacy: implement short slot and basic rate handling
> 
> This implements proper short slot handling and adds code to
> program the hardware for the correct response rates derived
> from the basic rate set for the current BSS.
> 
> (port from b43)
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Needs testing, I'm not 100% sure about those shm offsets.

I will be able to test in about a week. I'm currently on the road and I don't
have that computer with me.

Larry
