Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42607 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbbEDPlW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 11:41:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YpIUc-0003kd-WB
	for linux-wireless@vger.kernel.org; Mon, 04 May 2015 17:41:15 +0200
Received: from data-214-110.cgates.lt ([data-214-110.cgates.lt])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2015 17:41:14 +0200
Received: from nerijus by data-214-110.cgates.lt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2015 17:41:14 +0200
To: linux-wireless@vger.kernel.org
From: Nerijus =?utf-8?b?QmFsacWrbmFz?= <nerijus@users.sourceforge.net>
Subject: Re: b43 AP does not work
Date: Mon, 4 May 2015 15:41:03 +0000 (UTC)
Message-ID: <loom.20150504T173700-271@post.gmane.org> (sfid-20150504_174127_015934_63CBF369)
References: <loom.20150502T183011-57@post.gmane.org>  <5544FFE5.5090706@lwfinger.net> <loom.20150502T190504-905@post.gmane.org>  <loom.20150502T191744-147@post.gmane.org> <1430752777.17017.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@...> writes:

> > Just FYI - "access point" mode of the NM applet works (in Gnome). But it
> > would still be nice to have hostapd working.
> 
> If you want to use hostapd on the card and the system is running
> NetworkManager, you can tell NM to ignore the device through the
> "unmanaged-devices" option in NetworkManager.conf.  manpages have more
> details.

But I don't want NM to ignore the device - I use the wifi card with NM
as a client. But sometimes I'd like to use hostapd directly (as NM
does not allow me to configure AP parameters - channel, wpa number,
AP name and password). It was possible before, but not any more.

Thanks,
Nerijus

