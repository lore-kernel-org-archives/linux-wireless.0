Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:47736 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3CERWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 12:22:25 -0500
Received: by mail-ob0-f173.google.com with SMTP id dn14so2783462obc.4
        for <linux-wireless@vger.kernel.org>; Tue, 05 Mar 2013 09:22:24 -0800 (PST)
Message-ID: <513629CE.4020307@lwfinger.net> (sfid-20130305_182231_309498_84130077)
Date: Tue, 05 Mar 2013 11:22:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Stations disconnected due to no activity in latest wireless-testing.
References: <513627C4.5040207@candelatech.com>
In-Reply-To: <513627C4.5040207@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2013 11:13 AM, Ben Greear wrote:
> I'm trying the 3.9.0-rc1-wl+, and wlan0 is disconnecting almost immediately
> after it connects, supposedly because of inactivity....
>
> Is this a known issue?

Not here. Which driver or drivers are involved? I have tested with b43 on a 
BCM4312 and rtl8723ae.

Larry


