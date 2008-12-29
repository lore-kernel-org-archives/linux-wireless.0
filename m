Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:34543 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYL2GNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 01:13:34 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1673796fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2008 22:13:32 -0800 (PST)
To: Greg KH <gregkh@suse.de>
Cc: Pavel Roskin <proski@gnu.org>, Claudio <der.claudio@aon.at>,
	linux-wireless@vger.kernel.org
Subject: Re: status of at76-usb driver
References: <1230411118.4956956ecb911@webmail.aon.at>
	<87fxk8o2g0.fsf@litku.valot.fi> <1230499683.25726.4.camel@dv>
	<20081229003321.GA7426@suse.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 29 Dec 2008 08:13:28 +0200
In-Reply-To: <20081229003321.GA7426@suse.de> (Greg KH's message of "Sun\, 28 Dec 2008 16\:33\:21 -0800")
Message-ID: <87y6xzqzjr.fsf@litku.valot.fi> (sfid-20081229_071338_704128_023623D0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH <gregkh@suse.de> writes:

> On Sun, Dec 28, 2008 at 04:28:03PM -0500, Pavel Roskin wrote:
>> On Sun, 2008-12-28 at 15:26 +0200, Kalle Valo wrote:
>> 
>> > Also I'm going to rename the mac80211 port to something else for just
>> > to avoid the confusion with the original driver. Last thing I want to
>> > see is having two in-tree drivers with identical names.
>> 
>> I asked to rename the driver that was imported into the staging tree,
>> but my request was ignored.
>
> You did?  I don't see that in my email archives, sorry, did you cc: me?
>
>> I guess nobody really cares about the name conflict.
>
> What name conflict?  Is there in in-kernel with this same name for a
> module?

Not yet, but there will be once I manage to get the mac80211 port
usable.

> If so, let me know and I'll be glad to rename the staging one.

I can rename the mac80211 port, it's less confusing for the users.
Please don't rename the staging driver.

>> Once the mac80211 port is working properly, it should be included in
>> to the next kernel release, and the driver from the staging tree
>> should be removed in the same kernel release.
>
> When a "real" driver is included, I will be glad to delete the staging
> driver.  Just let me know.

I have to disagree with Pavel here. We should have a proper transition
period, because I'm sure that there will be problems with the new
driver. The staging driver doesn't create any harm, quite the opposite
actually.

Greg, I'll let you know when I think the staging driver can be
removed.

-- 
Kalle Valo
