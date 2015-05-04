Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55503 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbbEDTAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 15:00:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YpLbA-0000YK-Ax
	for linux-wireless@vger.kernel.org; Mon, 04 May 2015 21:00:12 +0200
Received: from data-214-110.cgates.lt ([data-214-110.cgates.lt])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2015 21:00:12 +0200
Received: from nerijus by data-214-110.cgates.lt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2015 21:00:12 +0200
To: linux-wireless@vger.kernel.org
From: Nerijus =?utf-8?b?QmFsacWrbmFz?= <nerijus@users.sourceforge.net>
Subject: Re: b43 AP does not work
Date: Mon, 4 May 2015 19:00:07 +0000 (UTC)
Message-ID: <loom.20150504T205530-427@post.gmane.org> (sfid-20150504_210019_212672_2B59BC80)
References: <loom.20150502T183011-57@post.gmane.org>   <5544FFE5.5090706@lwfinger.net> <loom.20150502T190504-905@post.gmane.org>   <loom.20150502T191744-147@post.gmane.org>  <1430752777.17017.2.camel@redhat.com>  <loom.20150504T173700-271@post.gmane.org> <1430760100.10844.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@...> writes:

> NM actually does allow you to do that by editing the hotspot connection
> files directly.

> If you take a look into /etc/NetworkManager/system-connections/ you
> should see the config file, where you can edit stuff like 'channel',
> 'ssid', 'band', 'pairwise', 'group', 'proto', etc, stuff that's familiar
> to wpa_supplicant config too.  See 'man nm-settings' for more details on
> all these key/value pairs.

I edited /etc/NetworkManager/system-connections/Hotspot, ran systemctl
restart NetworkManager and ssid and password were changed. Then I added
channel=10 to the file, restarted NM, but when I enable hotspot in Gnome,
ssid is localhost.localdomain and password is random again. I was not able
to have my edited ssid and password values back.

