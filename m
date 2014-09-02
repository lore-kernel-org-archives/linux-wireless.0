Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54107 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbaIBHzV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 03:55:21 -0400
Message-ID: <1409644512.1808.2.camel@jlt4.sipsolutions.net> (sfid-20140902_095528_487875_DEE22277)
Subject: Re: wmediumd performance penalty
From: Johannes Berg <johannes@sipsolutions.net>
To: Dani Camps <danicamps81@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 02 Sep 2014 09:55:12 +0200
In-Reply-To: <CAD3NH5Wimu9muPeL-zFrw=u1G3Q+8749cj0SYUmeQuLF6LKibQ@mail.gmail.com> (sfid-20140902_093201_597643_76A01DA7)
References: <CAD3NH5X1AYR5p8AyRyO0DFkkJUtuc_78=s6vEi-nS4UxUZfWCg@mail.gmail.com>
	 <1409597534.2703.9.camel@jlt4.sipsolutions.net>
	 <CAD3NH5Wimu9muPeL-zFrw=u1G3Q+8749cj0SYUmeQuLF6LKibQ@mail.gmail.com>
	 (sfid-20140902_093201_597643_76A01DA7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-09-02 at 09:31 +0200, Dani Camps wrote:
> Hi,
> 
> I am running on a virtual machine with Ubuntu. Does mac80211_hwsim not
> schedule the packet reception time to the other radio(s) according to
> the PHY rate in the packet in order to simulate transmission time over
> the air ?

No, it schedules it immediately.

johannes

