Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55058 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab1EFRTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 13:19:33 -0400
Received: by pwi15 with SMTP id 15so1514273pwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 10:19:33 -0700 (PDT)
Message-ID: <4DC42DA1.9020709@lwfinger.net> (sfid-20110506_191937_016162_BA3B8341)
Date: Fri, 06 May 2011 12:19:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Tom Horsley <horsley1953@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8192cu AP mode?
References: <20110506081356.08ac93a8@tomh>	<4DC40CEB.5010107@lwfinger.net> <20110506123526.53b75672@tomh>
In-Reply-To: <20110506123526.53b75672@tomh>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/06/2011 11:35 AM, Tom Horsley wrote:
> On Fri, 06 May 2011 09:59:55 -0500
> Larry Finger wrote:
>
>> If not, you can always get the compat-wireless
>> sources from http://wireless.kernel.org/en/users/Download.
>
> Well, the mac80211 code won't compile with the fedora
> 2.6.35 kernel headers because there isn't a kfree_rcu
> that far back in time, so I probably need to see about
> either updating the kernel or back porting some kind
> of kfree_rcu hack just for the mac80211 driver build.

That compilation problem was reported this morning on the mailing list. I expect 
that it will be fixed within a day or so.

I am currently testing rtl8192cu as an AP using hostapd. It is transmitting 
beacons and a station can authenticate and associate using WPA2. The only 
problem I'm having is that the station is not getting an IP number using dhcpd, 
but I don't think that is a problem with rtl8192cu. Once I get it sorted out, 
I'll send you my script for starting the AP.

Larry
