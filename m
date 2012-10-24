Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44149 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab2JXX4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 19:56:20 -0400
Message-ID: <50888021.4050300@candelatech.com> (sfid-20121025_015624_247548_ED1CC9A2)
Date: Wed, 24 Oct 2012 16:56:17 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kelly Hogan <kshogan@bluemesh.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Is Multi-Vif (vaps)  Different Channel Operation Supported?
References: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net> <50880BD0.6080603@candelatech.com> <1351093332.10709.5.camel@jlt4.sipsolutions.net> <5DA0F03B-BA8C-4D9F-A9F1-0841D6774255@bluemesh.net>
In-Reply-To: <5DA0F03B-BA8C-4D9F-A9F1-0841D6774255@bluemesh.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2012 04:05 PM, Kelly Hogan wrote:
> Hi All,
>
> We are utilizing current ath9k and mac80211 and are trying to discern if multi-channel support is possible on different Vifs, on the same phy.
>
> Example:
>
> Two Vifs running as masters, controlled via hostapd
> One Vif running as a Station, controlled by wpa_supplicant
> One Vif running as a mesh vap
>
> We can run all the Vifs fine, but it appears that with shared hostapd/wpa_supplicant control files, that the master Vifs always have to follow the channel that the station is connected to.  The mesh vap also seems to require being on the same channel of the station.
>
> Any info on if this is supported, or what order to process creation, channel setting, etc to get them to simultaneously allow different channel support would be helpful, or save us the time of assuming that it can be done if it in fact can't.

It cannot work as far as I know.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

