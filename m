Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33047 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbbEDUez (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 16:34:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YpN4n-0005S3-ON
	for linux-wireless@vger.kernel.org; Mon, 04 May 2015 22:34:53 +0200
Received: from data-214-110.cgates.lt ([data-214-110.cgates.lt])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2015 22:34:53 +0200
Received: from nerijus by data-214-110.cgates.lt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2015 22:34:53 +0200
To: linux-wireless@vger.kernel.org
From: Nerijus =?utf-8?b?QmFsacWrbmFz?= <nerijus@users.sourceforge.net>
Subject: Re: b43 AP does not work
Date: Mon, 4 May 2015 20:34:47 +0000 (UTC)
Message-ID: <loom.20150504T222913-980@post.gmane.org> (sfid-20150504_223458_662133_00B4DE5D)
References: <loom.20150502T183011-57@post.gmane.org>     <5544FFE5.5090706@lwfinger.net>  <loom.20150502T190504-905@post.gmane.org>     <loom.20150502T191744-147@post.gmane.org>    <1430752777.17017.2.camel@redhat.com>    <loom.20150504T173700-271@post.gmane.org>   <1430760100.10844.6.camel@redhat.com>   <loom.20150504T205530-427@post.gmane.org>  <1430767700.10844.24.camel@redhat.com>  <loom.20150504T222029-729@post.gmane.org> <1430771240.10844.25.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@...> writes:

> > I did
> > nmcli con reload
> > nmcli con up Hotspot
> > 
> > but it still used localhost.localdomain as ssid, although I have
> > ssid=something in /etc/NetworkManager/system-connections/Hotspot
> 
> If you run "nmcli con", is there more than one connection called
> "Hotspot"?  If not, then run "nmcli con Hotspot" and lets see what it
> prints out.

Yes, there are 2 Hotspots. After I deleted one with nm-connection-editor
the ssid is OK.

