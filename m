Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:10865 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZDPIj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 04:39:58 -0400
Received: by fg-out-1718.google.com with SMTP id e12so89651fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 01:39:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ws9lf8c4.fsf@litku.valot.fi>
References: <49E632A1.1050605@gmail.com> <20090415212103.GA5202@kroah.com>
	 <87ws9lf8c4.fsf@litku.valot.fi>
Date: Thu, 16 Apr 2009 12:39:56 +0400
Message-ID: <73aaf0dd0904160139o159a604fv5b3ff0801124d1d3@mail.gmail.com> (sfid-20090416_104004_866938_9EAC5E99)
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
From: Max Filippov <jcmvbkbc@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Greg KH <greg@kroah.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>, dcbw@redhat.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I have received a report that at76_usb has worked better than
> at76c50x-usb. Also p54spi implementation is quite new and not that much
> tested.
>
> If it's ok for you, I would like to have both at76_usb and stlc45xx in
> the staging area for some time still. I will let you know when they can
> be removed.
>
> --
> Kalle Valo

Kalle, what is the primary location for stlc45xx sources then? I see
that version in staging is pretty old.
-- 
Max
