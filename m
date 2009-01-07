Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:57905 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbZAGGEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 01:04:51 -0500
Received: by bwz14 with SMTP id 14so25051898bwz.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 22:04:49 -0800 (PST)
Message-ID: <da94abde0901062204r1041cdeawf0a0360cad88741d@mail.gmail.com> (sfid-20090107_070455_011545_19F07E56)
Date: Wed, 7 Jan 2009 08:04:49 +0200
From: "Kalle Valo" <kalle.valo@iki.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: status of at76-usb driver
Cc: Claudio <der.claudio@aon.at>, linux-wireless@vger.kernel.org,
	"Greg KH" <gregkh@suse.de>
In-Reply-To: <20090106201517.GD3544@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1230411118.4956956ecb911@webmail.aon.at>
	 <87fxk8o2g0.fsf@litku.valot.fi> <20090106201517.GD3544@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 6, 2009 at 10:15 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Sun, Dec 28, 2008 at 03:26:55PM +0200, Kalle Valo wrote:
>
>> Also I'm going to rename the mac80211 port to something else for just
>> to avoid the confusion with the original driver. Last thing I want to
>> see is having two in-tree drivers with identical names.
>
> OK, I still have patches to recreate the original port of at76_usb
> to mac80211 and another to keep-up with a later mac80211 API change
> on the at76 branch of wireless-testing.  I had intended to send them
> to Greg now that the mac80211 API change has made it upstream.

I have to disagree here. It's better not to change at76_usb in staging
to avoid any breakage. Like I said, I will submit the mac80211 port
with a new name (most probably at76c50x-usb) as soon as I get it
stable enough. It's good idea to have a working driver in staging tree
until the mac80211 has been verified to be working.

> Since you mentioned a) that you are working on the port again and b)
> you are going to rename the driver for mac80211, should I just drop
> my at76 branch of wireless testing for good?

Please do, because I will submit at7650x-usb patches from scratch. But
don't remove at76 branch from the legacy tree, it's useful for me:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-legacy.git;a=shortlog;h=at76

Kalle
