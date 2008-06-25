Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:40097 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbYFYIIW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 04:08:22 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KBQ37-0000E7-EC
	for linux-wireless@vger.kernel.org; Wed, 25 Jun 2008 08:08:17 +0000
Received: from lst-amand-152-33-14-15.w82-127.abo.wanadoo.fr ([82.127.45.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 08:08:17 +0000
Received: from fabien by lst-amand-152-33-14-15.w82-127.abo.wanadoo.fr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 08:08:17 +0000
To: linux-wireless@vger.kernel.org
From: Fabien Crespel <fabien@crespel.net>
Subject: Re: [PATCH 04/13] rfkill: add parameter to disable radios by   default
Date: Wed, 25 Jun 2008 10:11:54 +0200
Message-ID: <4861FDCA.1040505@crespel.net> (sfid-20080625_100827_444690_DF7F1FA0)
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br> <1214252588-30723-5-git-send-email-hmh@hmh.eng.br> <g3quvb$8sa$1@ger.gmane.org> <g3r9hn$av5$1@ger.gmane.org> <20080624231751.GA28975@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <20080624231751.GA28975@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> Sounds interesting.  But is this functionality worth the hassle of
> implementing it?

For the end user, I think it's better to have the device state restored 
at boot time if it's possible. Even though it can be tricky to 
implement, as you outlined.

- Fabien.

