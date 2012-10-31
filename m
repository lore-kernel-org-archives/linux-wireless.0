Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:37232 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab2JaFQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 01:16:21 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so459263dak.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2012 22:16:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgUQ40YW-dwy34nPD65XPWt1VWetyXDdd=L_NxKJ9-_Fiw@mail.gmail.com>
References: <508EB783.9080000@candelatech.com>
	<CAGRGNgWGfL+_u4fHEfqZAcFHb1H4Z4jFkiE4qKLU6i9XEWzZ6w@mail.gmail.com>
	<5090560D.1090708@candelatech.com>
	<CAGRGNgUQ40YW-dwy34nPD65XPWt1VWetyXDdd=L_NxKJ9-_Fiw@mail.gmail.com>
Date: Tue, 30 Oct 2012 22:16:20 -0700
Message-ID: <CAJ-Vmoky+46E71wQbF1-J-xEnHdWeMMXf=Yo+SGkqALjvjrJrg@mail.gmail.com> (sfid-20121031_061630_138984_B6E4166F)
Subject: Re: Any thoughts on how to best shield u.fl connectors on NICs?
From: Adrian Chadd <adrian@freebsd.org>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 October 2012 16:45, Julian Calaby <julian.calaby@gmail.com> wrote:

> That's a good point, all the NICs I've looked at closely (e.g. the
> rt2500usb cards on my desk at the moment) have an antenna or u.fl
> connector with some passive components around it and usually the
> antenna trace runs exposed on the board for a couple of millimetres
> before it disappears under the shielding around the RF chip. I'll
> check my collection at home tonight, but I'm pretty sure that all the
> PCI cards have a couple of cm of exposed antenna trace between the SMA
> connector and the RF shield.

I've even seen ${COMMERCIAL} kit do this internally.

Ben, what are you worried about in particular?




Adrian
