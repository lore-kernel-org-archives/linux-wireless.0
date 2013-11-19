Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38836 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3KSEBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 23:01:34 -0500
Message-ID: <528AE29B.3010101@candelatech.com> (sfid-20131119_050137_688588_242869B1)
Date: Mon, 18 Nov 2013 20:01:31 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Gustavo Azambuja <gazambuja+hostapd@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: NL80211_CMD_NEW_STATION result: -105 (No buffer space available)
References: <CABGE7dsDtL0ZPAmOTW=G=hMdA-6r=yT0DtQx_-H6Yi6cGa6Udw@mail.gmail.com> <CABGE7dur4pM4vLz_iLx7u-g5ohKhXkwKAOmjJ86PE62mYwGPJw@mail.gmail.com>
In-Reply-To: <CABGE7dur4pM4vLz_iLx7u-g5ohKhXkwKAOmjJ86PE62mYwGPJw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2013 06:20 PM, Gustavo Azambuja wrote:
> Hi, I recently installed in my raspberry pi Raspbian with hostapd 1.0, I
> want to make my own Hotspot, but follow all tutorials, I can only get up to
> 6 stations connected at the same time.
>
> The next error apper with the #7 client try to connect:
> *NL80211_CMD_NEW_STATION result: -105 (No buffer space available)*
>
> How I can resize this and make more clients can connect to my device?
>
> Im using TL-WN722N dongle.

You are probably hitting the firmware limit.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

