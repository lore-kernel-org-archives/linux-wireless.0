Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57527 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbZDPJwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 05:52:09 -0400
Received: by fxm2 with SMTP id 2so307108fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 02:52:08 -0700 (PDT)
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Greg KH <greg@kroah.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>, dcbw@redhat.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
References: <49E632A1.1050605@gmail.com> <20090415212103.GA5202@kroah.com>
	<87ws9lf8c4.fsf@litku.valot.fi>
	<73aaf0dd0904160139o159a604fv5b3ff0801124d1d3@mail.gmail.com>
	<87zleh9e89.fsf@litku.valot.fi>
	<73aaf0dd0904160214hff956aek77290380f81aa709@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 12:52:06 +0300
In-Reply-To: <73aaf0dd0904160214hff956aek77290380f81aa709@mail.gmail.com> (Max Filippov's message of "Thu\, 16 Apr 2009 13\:14\:30 +0400")
Message-ID: <87k55l9b95.fsf@litku.valot.fi> (sfid-20090416_115216_811162_D4836AF3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Max Filippov <jcmvbkbc@gmail.com> writes:

>>> Kalle, what is the primary location for stlc45xx sources then?
>>
>> I have been thinking about using staging the primary location. What do
>> you think?
>
> Partly agree: drivers/staging is better than gitorious and there are
> more potential testers than at stlc45xx-devel@garage.maemo.org.

Good.

> But I don't realize what is the purpose to have two drivers for one
> hw? p54spi IMHO only lacks firmware restart feature now. And most of
> the p54 code is used collectively by the pci, usb and spi, so it is
> probably more tested than stlc45xx.

p54spi is definitely the future. Christian and you have done great work
to get p54spi working N800/N810.

-- 
Kalle Valo
