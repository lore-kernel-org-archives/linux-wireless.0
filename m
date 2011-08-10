Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:40269 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab1HJLkL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 07:40:11 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Qr78r-0003fE-T9
	for linux-wireless@vger.kernel.org; Wed, 10 Aug 2011 13:40:10 +0200
Received: from 203.200.200.74.ill-bgl.static.vsnl.net.in ([203.200.200.74.ill-bgl.static.vsnl.net.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 13:40:09 +0200
Received: from amit.gemini by 203.200.200.74.ill-bgl.static.vsnl.net.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 13:40:09 +0200
To: linux-wireless@vger.kernel.org
From: =?utf-8?b?YW1pdC5nZW1pbmlAc2Fza2VuLmNvbQ==?=
	<amit.gemini@sasken.com>
Subject: Re: Problem bringing up wlan0 interface up with mainline wl1271 drivers
Date: Wed, 10 Aug 2011 11:34:01 +0000 (UTC)
Message-ID: <loom.20110810T133206-617@post.gmane.org> (sfid-20110810_134015_424829_70A4E47A)
References: <57CB308D-7237-46D7-9AF8-7093F52682E8@mac.com>  <AANLkTikESPwcaxUSDd3B=Oh7kBD-QpndKRHmu9-roDqs@mail.gmail.com>  <C77CCCD3-2467-4363-A513-05B68B9F57F6@mac.com>  <E680F3C4CE6F415E95DCBDA48F0158FC@MINX0125717>  <98BC4735-664C-491E-80CE-356BE32FA2ED@mac.com>  <AANLkTinejL9LeocQPzjrqrCFYbrF9wqpD9dSyfEVu8us@mail.gmail.com>  <C4B3622F-ADC4-481E-9340-1819C815184A@mac.com>  <AANLkTikvk+AqKRr1VbKv9pSHicy7PAGu8GkdeZuvYwFh@mail.gmail.com>  <397FC41E-7F1D-4AA8-9D09-6121BB0169E7@mac.com> <1292582324.18083.7.camel@chilepepper>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > 
> > [   63.852264] wl1271: ERROR could not get nvs file: -2
> > [   63.906250] wl1271: loaded
> > [   63.909271] wl1271: initialized
> 
> You need to start udevd.  The driver gets the firmware via udev.
> 

 Hi Elvis, and Arik,

         i am also having same problem , and i dont' know how to start udevd on
Panda Board.. can you help me ...


