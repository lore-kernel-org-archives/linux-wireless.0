Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45371 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbbEDQWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 12:22:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YpJ85-00058w-Em
	for linux-wireless@vger.kernel.org; Mon, 04 May 2015 18:22:01 +0200
Received: from data-214-110.cgates.lt ([data-214-110.cgates.lt])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2015 18:22:01 +0200
Received: from nerijus by data-214-110.cgates.lt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2015 18:22:01 +0200
To: linux-wireless@vger.kernel.org
From: Nerijus =?utf-8?b?QmFsacWrbmFz?= <nerijus@users.sourceforge.net>
Subject: Re: b43 AP does not work
Date: Mon, 4 May 2015 16:21:55 +0000 (UTC)
Message-ID: <loom.20150504T181817-501@post.gmane.org> (sfid-20150504_182210_942055_FC01CD65)
References: <loom.20150502T183011-57@post.gmane.org>  <5544FFE5.5090706@lwfinger.net> <loom.20150502T190504-905@post.gmane.org>  <loom.20150502T191744-147@post.gmane.org> <1430752777.17017.2.camel@redhat.com> <loom.20150504T173700-271@post.gmane.org> <55479714.1060007@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:

> > But I don't want NM to ignore the device - I use the wifi card with NM
> > as a client. But sometimes I'd like to use hostapd directly (as NM
> > does not allow me to configure AP parameters - channel, wpa number,
> > AP name and password). It was possible before, but not any more.
> 
> That is an applet problem. I use openSUSE 13.2 with a KDE desktop, and the 
> Connection Manager lets me specify everything in your list but perhaps the
WPA 
> level, but why would you want to use anything less secure than WPA2?
> 
> You need to complain to your distro if they have a regression in the NM
applet.

It's Gnome, they don't let users to configure :( But thanks, next time I
will know that KDE applet is better.
Does anyone know why it was possible before? Is it NM or hostapd regression?

