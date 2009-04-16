Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53571 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZDPF6j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 01:58:39 -0400
Received: by bwz17 with SMTP id 17so215937bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 22:58:37 -0700 (PDT)
To: Greg KH <greg@kroah.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, dcbw@redhat.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
References: <49E632A1.1050605@gmail.com> <20090415212103.GA5202@kroah.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 08:58:35 +0300
In-Reply-To: <20090415212103.GA5202@kroah.com> (Greg KH's message of "Wed\, 15 Apr 2009 14\:21\:04 -0700")
Message-ID: <87ws9lf8c4.fsf@litku.valot.fi> (sfid-20090416_075843_458427_EC836321)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH <greg@kroah.com> writes:

> Note, whenever a "real" wireless driver goes into the tree that
> obsoletes any of the staging drivers, please let me know and I'll
> instantly remove it.
>
> Right now the otus code is staying because the ar9170 developers want it
> to.
>
> But what about at76_usb?  stlc45xx?  Do they now have workable drivers
> to replace them in the tree today?  If so, _please_ let me know.

I have received a report that at76_usb has worked better than
at76c50x-usb. Also p54spi implementation is quite new and not that much
tested.

If it's ok for you, I would like to have both at76_usb and stlc45xx in
the staging area for some time still. I will let you know when they can
be removed.

-- 
Kalle Valo
