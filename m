Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from warsl404pip5.highway.telekom.at ([195.3.96.77]:27239 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752358AbZAHO4t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 09:56:49 -0500
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: status of at76-usb driver
Message-ID: <1231426604.4966142c2f17c@webmail.aon.at> (sfid-20090108_155653_760894_32D95E4D)
Date: Thu, 08 Jan 2009 15:56:44 +0100 (CET)
From: Claudio <der.claudio@aon.at>
Cc: "\"John W. Linville\"" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Greg KH <gregkh@suse.de>
References: <1230411118.4956956ecb911@webmail.aon.at>  <87fxk8o2g0.fsf@litku.valot.fi> <20090106201517.GD3544@tuxdriver.com> <da94abde0901062204r1041cdeawf0a0360cad88741d@mail.gmail.com>
In-Reply-To: <da94abde0901062204r1041cdeawf0a0360cad88741d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> wrote:
> On Tue, Jan 6, 2009 at 10:15 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Sun, Dec 28, 2008 at 03:26:55PM +0200, Kalle Valo wrote:
>>
>>> Also I\'m going to rename the mac80211 port to something else for just
>>> to avoid the confusion with the original driver. Last thing I want to
>>> see is having two in-tree drivers with identical names.
>>
>> OK, I still have patches to recreate the original port of at76_usb
>> to mac80211 and another to keep-up with a later mac80211 API change
>> on the at76 branch of wireless-testing.  I had intended to send them
>> to Greg now that the mac80211 API change has made it upstream.
>
> I have to disagree here. It\'s better not to change at76_usb in staging
> to avoid any breakage. Like I said, I will submit the mac80211 port
> with a new name (most probably at76c50x-usb) as soon as I get it
> stable enough. It\'s good idea to have a working driver in staging tree
> until the mac80211 has been verified to be working.

I think so too.

>> Since you mentioned a) that you are working on the port again and b)
>> you are going to rename the driver for mac80211, should I just drop
>> my at76 branch of wireless testing for good?
>
> Please do, because I will submit at7650x-usb patches from scratch. But
> don\'t remove at76 branch from the legacy tree, it\'s useful for me:

I am looking forward for testing your new mac80211 version. Please tell
me where the development happens, so that I can contribute to it.

Regarding Ubuntu: They are still shipping an ancient version (0.14beta1!).
Sorry for considering blaming you for the problems. The current version
of the staging-tree/directory(?) works well.

Claudio
