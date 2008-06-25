Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:37688 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbYFYHTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 03:19:31 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KBPHp-0006pz-OW
	for linux-wireless@vger.kernel.org; Wed, 25 Jun 2008 07:19:25 +0000
Received: from lst-amand-152-33-14-15.w82-127.abo.wanadoo.fr ([82.127.45.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 07:19:25 +0000
Received: from fabien by lst-amand-152-33-14-15.w82-127.abo.wanadoo.fr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 07:19:25 +0000
To: linux-wireless@vger.kernel.org
From: Fabien Crespel <fabien@crespel.net>
Subject: Re: [PATCH 04/13] rfkill: add parameter to disable radios by    default
Date: Wed, 25 Jun 2008 09:23:01 +0200
Message-ID: <4861F255.9030504@crespel.net> (sfid-20080625_091936_966511_E8103303)
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>	 <1214252588-30723-5-git-send-email-hmh@hmh.eng.br>	 <g3quvb$8sa$1@ger.gmane.org>  <g3r9hn$av5$1@ger.gmane.org>	 <1214330213.23127.9.camel@localhost.localdomain>	 <48615925.8010203@crespel.net> <1214344159.11980.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <1214344159.11980.21.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
 >
 > Yeah, but what driver -is- that?  asus-laptop or something?
 >

It's asus-laptop, but only my own version of it. The current official 
version simply turns the devices on when loading. I sent a patch for 
this and other features (kill switch awareness, suspend/resume 
handlers...) a few months ago but it wasn't included, and anyway 
asus-laptop needs a major rework to use the input layer and rfkill. I've 
started working on it, and I'll post about it soon.

- Fabien.

