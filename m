Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:18553 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZDPJOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 05:14:31 -0400
Received: by fg-out-1718.google.com with SMTP id e12so94204fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 02:14:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87zleh9e89.fsf@litku.valot.fi>
References: <49E632A1.1050605@gmail.com> <20090415212103.GA5202@kroah.com>
	 <87ws9lf8c4.fsf@litku.valot.fi>
	 <73aaf0dd0904160139o159a604fv5b3ff0801124d1d3@mail.gmail.com>
	 <87zleh9e89.fsf@litku.valot.fi>
Date: Thu, 16 Apr 2009 13:14:30 +0400
Message-ID: <73aaf0dd0904160214hff956aek77290380f81aa709@mail.gmail.com> (sfid-20090416_111433_874862_3A692721)
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

>> Kalle, what is the primary location for stlc45xx sources then?
>
> I have been thinking about using staging the primary location. What do
> you think?

Partly agree: drivers/staging is better than gitorious and there are
more potential testers than at stlc45xx-devel@garage.maemo.org.
But I don't realize what is the purpose to have two drivers for one
hw? p54spi IMHO only lacks firmware restart feature now. And most of
the p54 code is used collectively by the pci, usb and spi, so it is
probably more tested than stlc45xx.

-- 
Max
