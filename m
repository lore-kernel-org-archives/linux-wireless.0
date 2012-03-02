Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46602 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab2CBTDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 14:03:40 -0500
Received: by iagz16 with SMTP id z16so2653712iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2012 11:03:40 -0800 (PST)
Message-ID: <4F511989.8040508@lwfinger.net> (sfid-20120302_200344_864939_AB0CF849)
Date: Fri, 02 Mar 2012 13:03:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Patrick McMunn <doctorwhoguy@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Problem with b43 driver
References: <CAKS+cu2g45-KvQdvT=5B8p7dCt76dwXgNjMSUARM5+v8Mz9joQ@mail.gmail.com>
In-Reply-To: <CAKS+cu2g45-KvQdvT=5B8p7dCt76dwXgNjMSUARM5+v8Mz9joQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/02/2012 11:59 AM, Patrick McMunn wrote:
> A while back, a fix was issued for the b43 driver where the driver was
> not issuing beacons in ad-hoc mode (
> http://www.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.33/ChangeLog-2.6.33.20
> ). I have a card which uses the driver, and it did allow me to use
> ad-hoc mode for sharing an internet connection. However, I think there
> is still some problem with the driver. When I start up my laptop (with
> an Intel wireless card) and try to connect to the connection which I
> created on my desktop which uses the b43 driver, there are occasions
> when it detects the network immediately, and there are occasions when
> it never does detect it even if I go to my desktop and stop then
> restart the network. I may wait 15 or 20 minutes before giving up on
> it. At the same time, my laptop may detect 3 or 4 wireless networks
> from neighbors' homes, but it will not detect mine. So I suspect that
> the b43 driver is somehow issuing beacons inconsistently. I'll be
> happy to supply any additional information I can upon request. Another
> thing that may or may not be related is that even when I do connect,
> the machines can only ping each other if I connect using channel 10.
> No other channel seems to work even if they successfully connect.

Does your laptop have a reasonable operating system that will let you run 
wireshark in promiscuous mode? If so, please capture the traffic when you are 
having this problem and check to see if the beacons are present.

That problem of needing to use channel 10 seems a bit strange.

Larry

