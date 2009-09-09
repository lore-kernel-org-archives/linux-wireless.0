Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:27636 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZIICHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 22:07:16 -0400
Received: by qw-out-2122.google.com with SMTP id 9so237703qwb.37
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 19:07:19 -0700 (PDT)
Message-ID: <4AA70DD6.8040905@lwfinger.net>
Date: Tue, 08 Sep 2009 21:07:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: John Daiker <daikerjohn@gmail.com>, Michael Buesch <mb@bu3sch.de>,
	Dave Young <hidave.darkstar@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: b43 dma error
References: <20090908134732.GA1936@darkstar> <200909081638.36897.mb@bu3sch.de> 	<4AA67009.4020400@lwfinger.net> <4AA69961.9010808@gmail.com> 	<4AA69F61.2040300@lwfinger.net> <69e28c910909081124v71e6fa1cy815a2366385051e6@mail.gmail.com> 	<4AA6A2B3.2010300@lwfinger.net> <69e28c910909081132l464c2effq31665b22365de1c2@mail.gmail.com>
In-Reply-To: <69e28c910909081132l464c2effq31665b22365de1c2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After some tests with the 32-bit architecture, I'm now thoroughly
confused. I tried different memory models including PAE - everything
worked. I even generated a 2.6.31-rc9-wl kernel with John's config and
it worked. Whatever is happening is not related to his configuration.
I'm not sure what the problem is.

I'm going to be offline for a few days - I hope the solution will be
in my mailbox by the weekend.

Larry

