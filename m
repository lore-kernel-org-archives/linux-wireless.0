Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-forward1.uio.no ([129.240.10.70]:53505 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab2FSSwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 14:52:31 -0400
Received: from exim by mail-out1.uio.no with local-bsmtp (Exim 4.75)
	(envelope-from <Jon.Wikne@cern.ch>)
	id 1Sh3XS-00030w-0Z
	for linux-wireless@vger.kernel.org; Tue, 19 Jun 2012 20:52:30 +0200
Message-ID: <4FE0CA6C.3080002@cern.ch> (sfid-20120619_205234_104849_63C7F693)
Date: Tue, 19 Jun 2012 20:52:28 +0200
From: Jon Wikne <Jon.Wikne@cern.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
	Jon Wikne <Jon.Wikne@cern.ch>
Subject: Re: Mysterious hangs - cfg80211 - ath9k
References: <4FE03291.5030202@cern.ch> <CAD2nsn1U0UHjrDp7vh7rfvTP=BLB3FA+zLV9sgt1_T7gVvAYgg@mail.gmail.com>
In-Reply-To: <CAD2nsn1U0UHjrDp7vh7rfvTP=BLB3FA+zLV9sgt1_T7gVvAYgg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2012 11:39 AM, Mohammed Shafi wrote:
> On Tue, Jun 19, 2012 at 1:34 PM, Jon Wikne<Jon.Wikne@cern.ch>  wrote:
>> Hi List,
>>
>> I am experiencing a puzzling problem with WLAN on a Toshiba Qosmio
>> F750 laptop, running CERN SLC 5.8 (mostly identical to RHEL 5.8),
>> but with kernel 2.6.39.4. (The kernel that came with the distro did
>> not work properly with WLAN on this machine at all.)
>
> please quickly try
> http://linuxwireless.org/en/users/Download#Where_to_download_bleeding_edge

I tried to install compat-wireless-2012-05-10. It worked for 4½ hours,
then same problem.

Maybe there is something wrong with my understanding here, but I do not
see why the "cfg80211: Calling CRDA to update world regulatory domain"
should occur hours after the connection has been established, and what
triggers it, apparently at random....

> or the latest wireless testing tree
> http://linuxwireless.org/en/developers/Documentation/git-guide#Cloning_latest_wireless-testing

Is there a reason to believe it could make a difference if I try
this too?

Regards,
-- Jon Wikne
