Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:54768 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZG3NOc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 09:14:32 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MWVSo-0001NL-OL
	for linux-wireless@vger.kernel.org; Thu, 30 Jul 2009 13:14:30 +0000
Received: from dslb-084-058-206-191.pools.arcor-ip.net ([84.58.206.191])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 13:14:30 +0000
Received: from acid-burn by dslb-084-058-206-191.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 13:14:30 +0000
To: linux-wireless@vger.kernel.org
From: Mladen Horvat <acid-burn@opendreambox.org>
Subject: Re: zd1211rw couldn't load firmware. Error number -145 with Kernel =?utf-8?b?CTIuNi4zMA==?=
Date: Thu, 30 Jul 2009 13:14:18 +0000 (UTC)
Message-ID: <loom.20090730T131110-803@post.gmane.org>
References: <loom.20090729T111851-320@post.gmane.org>  <200907291350.27426.hs4233@mail.mn-solutions.de>  <loom.20090729T120228-576@post.gmane.org> <3ace41890907292043rad37b63y12cacfeb713dc575@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung <hintak.leung@...> writes:

> I noticed you have a particularly slow CPU (33MHz?)... the vendor
> driver has some preculiar coding to interrupt some operations to
> prevent deadlocks; I wonder if the rw driver inherit that? One of the
> patches in my patch set for the vendor driver put a delay right after
> firmware load;
> it might be appropriate to add something similiar to the rw driver.
> --

As i have written 
here  http://article.gmane.org/gmane.network.wireless.zd1211.devel/1736
the vendor 3.0 driver has no problem with the firmware upload and at least gets
an working interface up.

So i think this is definitively a driver problem with the zd1211rw.

regards

Mladen



