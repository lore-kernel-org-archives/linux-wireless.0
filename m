Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46416 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715Ab2BNQ5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 11:57:37 -0500
Received: by ghrr11 with SMTP id r11so133054ghr.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 08:57:36 -0800 (PST)
Message-ID: <4F3A927D.2050708@lwfinger.net> (sfid-20120214_175740_737694_71C77F80)
Date: Tue, 14 Feb 2012 10:57:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT 0/5] Firmware load change for various wireless drivers
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net>  (sfid-20120213_203726_939695_C63C1EE3) <1329217015.3941.8.camel@jlt3.sipsolutions.net>  <4F3A8D30.3040804@lwfinger.net> (sfid-20120214_173532_491396_64EB4078) <1329237440.3941.15.camel@jlt3.sipsolutions.net>
In-Reply-To: <1329237440.3941.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2012 10:37 AM, Johannes Berg wrote:
>
> I'm not even sure they've done *anything* until now, so I'm not sure it
> matters. I believe the behavioural change that prompted these changes
> will actually make it easier to implement the delay in a matter that
> covers both this and async loading, so you may well be safe, I haven't
> really understood the full details of the change that prompted all this.

I do not think the changes have been merged into any distro yet, but I have 
gotten feedback converning udev timeouts from the rtlwifi drivers when booting. 
That is the reason I'm trying to get ahead of the curve now.

Larry

