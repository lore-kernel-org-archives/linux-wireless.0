Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47320 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3ACJjw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 04:39:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TqhHQ-0000Af-IJ
	for linux-wireless@vger.kernel.org; Thu, 03 Jan 2013 10:40:04 +0100
Received: from p5b37ab64.dip.t-dialin.net ([91.55.171.100])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2013 10:40:04 +0100
Received: from jvpeetz by p5b37ab64.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2013 10:40:04 +0100
To: linux-wireless@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: wireless regression with 3.7 on MSI MS-1013 notebook
Date: Thu, 03 Jan 2013 10:27:35 +0100
Message-ID: <50E54F07.6030508@web.de> (sfid-20130103_103956_547827_26B3D119)
References: <50E42DBF.7070206@web.de> <20130102160534.GC2198@tuxdriver.com> <CAL1gcdMXNomEiPqJ5fKiQEB8Z02h=zYyYEUyDPvcaH4uEmd6jA@mail.gmail.com> <CAL1gcdN7TBS_yn5q5YsNVt8pkfLrxJLj=JSYQzM0J0jTEFAx-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAL1gcdN7TBS_yn5q5YsNVt8pkfLrxJLj=JSYQzM0J0jTEFAx-Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks everybody, meanwhile I'm using Helmut's patch
f5685ba675449b072feab6a5391a9ef9f604bc94, which indeed fixes this problem of my
oldtimer notebook.

@John W.: The problem happened every time, the notebook was booted. Besides the
warning message and the absent wlan interface, this computer seemed to work o.k.

-- 
Best regards,
Jörg-Volker.

