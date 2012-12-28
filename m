Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:40407 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2L1AEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 19:04:07 -0500
Received: by mail-da0-f48.google.com with SMTP id k18so4543579dae.21
        for <linux-wireless@vger.kernel.org>; Thu, 27 Dec 2012 16:04:07 -0800 (PST)
Message-ID: <50DCE1F3.806@lwfinger.net> (sfid-20121228_010411_479418_15D1B4BD)
Date: Thu, 27 Dec 2012 18:04:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alden Page <pagea@allegheny.edu>
CC: linux-wireless@vger.kernel.org
Subject: Re: bugreport Connectivity problems with rtl8192cu
References: <CABLZTyB12FX3e_yAoH7XOfhhA-pcv4GqzpfkBDNi64jdh5eCXA@mail.gmail.com>
In-Reply-To: <CABLZTyB12FX3e_yAoH7XOfhhA-pcv4GqzpfkBDNi64jdh5eCXA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/27/2012 05:43 PM, Alden Page wrote:

What is this doing here? You need to have either the in-kernel driver available, 
or the vendor driver. This bit shows you have both.

> [    5.448046] rtw driver version=v3.4.4_4749.20121105
> [    5.448049] Build at: Dec 20 2012 21:30:41
> [    5.448052] Error: Driver 'rtl8192cu' is already registered, aborting...

I doubt that this bit is the reason for any problems, but why tempt fate?

Larry

