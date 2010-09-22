Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:44168 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab0IVNyx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 09:54:53 -0400
Subject: Re: Manual Control about Sending ACKs
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Berger <daniel@dat-berger.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201009221545.41377.chunkeey@googlemail.com> (sfid-20100922_154601_624932_FFFFFFFFD00B9F23)
References: <20100922123953.67a4fc5e@danmob>
	 <20100922130245.GC5515@tuxdriver.com>
	 <201009221545.41377.chunkeey@googlemail.com>
	 (sfid-20100922_154601_624932_FFFFFFFFD00B9F23)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 15:54:47 +0200
Message-ID: <1285163687.15806.9.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-22 at 15:45 +0200, Christian Lamparter wrote:

> > I suspect you need to be looking at hacking firmware.
> > You might look at the open-source ar9170 firmware
> > or the b43-openfwwf project.
> 
> probably not ar9170 either.
> The ACK - mechanism (response control) is mostly hardwired in
> the chip, there is not much to control here.

The ack mechanism is implemented in firmware for the b43 chip and I
think it's understood pretty much completely how ACKing works in
the firmware. So you may want to take a look at b43-openfwwf.
The guys who created b43-openfwwf also experimented with this
kind of stuff, so you might want to contact them.

-- 
Greetings Michael.

