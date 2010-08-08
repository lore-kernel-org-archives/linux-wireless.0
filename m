Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab0HHCCw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 22:02:52 -0400
Subject: Re: Wifi GNOME network manager version into KUbuntu, Debian
 "pinning method, etc. ; jor linux-wireless-kernel
From: Dan Williams <dcbw@redhat.com>
To: giovanni_re <john_re@fastmail.us>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1281206754.31161.1388795015@webmail.messagingengine.com>
References: <1281206754.31161.1388795015@webmail.messagingengine.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 21:04:28 -0500
Message-ID: <1281233068.6235.5.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-08-07 at 11:45 -0700, giovanni_re wrote:
> KUbuntu 10.4,
> 
> =
> Failing to get wifi to connect to access point.  It can see APs, but
> fails to get dhcp via command mode, & fails connect with wicd.
> 
> =
> It has been suggested (on KUbuntu list?) to remove the KU network
> manager package, & that might get wicd & console command wifi working.

That could work, but it's better to do that for the short-term just to
verify that the wifi driver, kernel, and card are working correctly.  If
that's the case, there's no reason NetworkManager shouldn't work for
you.

> Previously, I was told that there is more networking success if one
> installs Ubuntu (not KUbuntu) [to get the Ubuntu/Gnome network manager
> sw], then install KDE on top of that.
> 
> =
> For a system that was installed as KUbuntu:
> 
> Might it be possible to use something like Debian "pinning" to hold back
> the KU network manager package, & then install the Ubuntu NetworkManager
> package?  Guess I'd at least have to ad the Ubuntu repositories to
> /etc/apt/sources.list.
> 
> There might also be another debian method to do this.
> 
> =
>  Being as Ubuntu is Debian based, is there some way to make this work?

This probably isn't the right list for this, but feel free to drop a
mail to networkmanager-list@gnome.org for more help.  You may get a
reply about "non-subscribers cannot post to list" but I'll moderate your
mail through since I'm the list admin.  More info here:

http://mail.gnome.org/mailman/listinfo/networkmanager-list

and we can try to debug your issue there.

Dan


> =
> I ran Debian from about 2000-2005, so haven't done pinning for a long
> time.
> 
> =
> Thanks :)
> 
> ==  Join in the Global weekly meetings, via VOIP, about all Free SW HW & Culture
> http://sites.google.com/site/berkeleytip/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


