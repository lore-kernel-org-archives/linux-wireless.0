Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56426 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772Ab2FGLEy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 07:04:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ScaWJ-0000gC-Ih
	for linux-wireless@vger.kernel.org; Thu, 07 Jun 2012 13:04:51 +0200
Received: from cph-ex1.sdesigns.com ([192.215.56.171])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 13:04:51 +0200
Received: from hanskroner by cph-ex1.sdesigns.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 13:04:51 +0200
To: linux-wireless@vger.kernel.org
From: Hans =?utf-8?b?S3LDtm5lcg==?= <hanskroner@gmail.com>
Subject: Re: mwifiex:Testing AP functionality with hostapd
Date: Thu, 7 Jun 2012 11:04:34 +0000 (UTC)
Message-ID: <loom.20120607T130146-946@post.gmane.org> (sfid-20120607_130457_370311_65A8313F)
References: <loom.20120607T100950-564@post.gmane.org> <CAJwzM1mTyOv6cUjTQ00-Q-5aW872kwyBPgnH9Pnk82fLZ+-J2w@mail.gmail.com> <loom.20120607T121239-785@post.gmane.org> <CAJwzM1n2-K+J5ado9fUVBNuOumAfp0R0kwHj6jFSuOFJHap61Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Avinash,

I'll try to build that version in a little while. At the time of that revision,
hostapd could not be linked against libnl-3. When you built the version you
tested against, were you using libnl-1 or libnl-2?

Could you provide me with the .config file you used to build hostapd so I can
be sure that I'm not including things I shouldn't be, or missing important
parts?

Thanks again!

Best Regards,

Hans

