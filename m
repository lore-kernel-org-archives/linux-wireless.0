Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36341 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbZDPIr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 04:47:56 -0400
Received: by fxm2 with SMTP id 2so280347fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 01:47:54 -0700 (PDT)
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Greg KH <greg@kroah.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>, dcbw@redhat.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
References: <49E632A1.1050605@gmail.com> <20090415212103.GA5202@kroah.com>
	<87ws9lf8c4.fsf@litku.valot.fi>
	<73aaf0dd0904160139o159a604fv5b3ff0801124d1d3@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 11:47:50 +0300
In-Reply-To: <73aaf0dd0904160139o159a604fv5b3ff0801124d1d3@mail.gmail.com> (Max Filippov's message of "Thu\, 16 Apr 2009 12\:39\:56 +0400")
Message-ID: <87zleh9e89.fsf@litku.valot.fi> (sfid-20090416_104800_703142_4C874041)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Max Filippov <jcmvbkbc@gmail.com> writes:

>> I have received a report that at76_usb has worked better than
>> at76c50x-usb. Also p54spi implementation is quite new and not that much
>> tested.
>>
>> If it's ok for you, I would like to have both at76_usb and stlc45xx in
>> the staging area for some time still. I will let you know when they can
>> be removed.
>
> Kalle, what is the primary location for stlc45xx sources then?

I have been thinking about using staging the primary location. What do
you think?

> I see that version in staging is pretty old.

Yeah, I have been planning to patch bomb Greg at some point with all the
patches from the stlc45xx git tree. It's just that n800 support is
currently broken in 2.6.30-rc1 from linux-omap tree :(

-- 
Kalle Valo
