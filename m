Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46381 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576AbbKESrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 13:47:12 -0500
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when building
 IEs.
To: linux-wireless@vger.kernel.org
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
Cc: johannes@sipsolutions.net
From: Ben Greear <greearb@candelatech.com>
Message-ID: <563BA42F.1060904@candelatech.com> (sfid-20151105_194715_482980_43DF151E)
Date: Thu, 5 Nov 2015 10:47:11 -0800
MIME-Version: 1.0
In-Reply-To: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/20/2015 10:24 AM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> If a user restricts the rateset for some reason, then the
> probe requests should not advertise rates that are not
> selected by the user.
>
> To implement this, we save the requested bitrates at
> the mac80211 level and take it into account when building
> the IEs.
>
> This allows one to create a more realistic /b mode
> station on modern hardware, for instance.  Good for
> testing, and likely good for other things as well.

Any comments on these patches?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

