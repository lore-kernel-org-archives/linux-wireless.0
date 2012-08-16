Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38236 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2HPSG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 14:06:28 -0400
Received: by yhmm54 with SMTP id m54so3202777yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Aug 2012 11:06:27 -0700 (PDT)
Message-ID: <502D36A0.2040400@lwfinger.net> (sfid-20120816_200634_058358_E5E8C459)
Date: Thu, 16 Aug 2012 13:06:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Richie Gress <searchfgold67899@live.com>
CC: linux-wireless@vger.kernel.org, 1030858@bugs.launchpad.net
Subject: Re: 0bda:8176 RTL8188CUS does not connect to wireless networks
References: <BLU0-SMTP344F6F7B3E1F2CD39D5B52CF2B50@phx.gbl>
In-Reply-To: <BLU0-SMTP344F6F7B3E1F2CD39D5B52CF2B50@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/15/2012 10:22 PM, Richie Gress wrote:
> [1] Summary of Problem.
> 0bda:8176 RTL8188CUS does not connect to wireless networks
>
> [2] Full description of the Problem.
> The RTL8188CUS USB wireless card will not connect to wireless networks. The connection is attempted over and over again, and the password prompt reappears each time if the network has one, but a connection is never established.
> There is a workaround for this bug: Drivers can be obtained from the Realtek website. But they are required in order for the hardware to function properly.

You gave quite a complete report, but you missed some important factors. What 
kind of wireless connection are you trying to make (802.11n, 802.11g, etc)? What 
kind of encryption? What is the make/model of the AP?

My tests show that rtl8192cu can make a connection for 802.11n and 802.11g, as 
long as the encryption is WPA2. With WPA or WEP encryption, an 802.11g 
connection fails as you describe.

I am now checking to see where this regression occurred. Please fill out a 
kernel bugzilla on this regression, and assign it to me.

Thanks,

Larry

