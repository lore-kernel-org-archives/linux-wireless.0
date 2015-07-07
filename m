Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:60831 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbbGGLyW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 07:54:22 -0400
Subject: Re: Clarification for the use of additional fields in the message
 body
To: Frans Klaver <fransklaver@gmail.com>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <558EB32E.6090003@users.sourceforge.net>
 <558EB4DE.3080406@users.sourceforge.net> <20150707023103.GA22043@kroah.com>
 <559B6FF8.9010704@users.sourceforge.net>
 <CAH6sp9Nn7LKdqT9E0bykY8jpEc-Ugxn8wby5yLcW+nsx=yG3NQ@mail.gmail.com>
 <559B85CD.6040200@users.sourceforge.net>
 <CAH6sp9Npqma18pj=ZsxYpCNDCm-AjjXvw61MGKBEKSYvg_LUBg@mail.gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Chris Park <chris.park@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Julia Lawall <julia.lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <559BBDD6.7040808@users.sourceforge.net> (sfid-20150707_135428_597596_1698C671)
Date: Tue, 7 Jul 2015 13:53:58 +0200
MIME-Version: 1.0
In-Reply-To: <CAH6sp9Npqma18pj=ZsxYpCNDCm-AjjXvw61MGKBEKSYvg_LUBg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I think that as far as these kernel mailing lists are concerned,
> the date of the update suggestion is the date on which you submitted the patch,
> rather than the date you originally committed it to your local tree.

I imagine that there are committers who would like to keep
corresponding software development history a bit more accurate.


> If you wish to keep track of this evolution for yourself, or
> wish to share it, you're better off stashing it somewhere in a
> (public) git repo that you control.

Would it be nicer to preserve such data directly also
by the usual mail interface?


> If you insist on placing the date somewhere, you can also put the date
> there if you wish. It'll be ignored by git when applied.

This content management tool provides the capability to store
the discussed information by the parameters "--author=" and "--date=",
doesn't it?
Is the environment variable "GIT_AUTHOR_DATE" also interesting occasionally?

How often do you take extra care for passing appropriate data there?

Regards,
Markus
