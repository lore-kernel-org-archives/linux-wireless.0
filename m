Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:58145 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbZHBQSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 12:18:06 -0400
Subject: Re: [PATCH 1/1] rfkill: add the GPS radio type
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240908020343j7308e215vc1914244c8cd191a@mail.gmail.com>
References: <1249169809-11853-1-git-send-email-tomas.winkler@intel.com>
	 <1249171448.3491.32.camel@localhost.localdomain>
	 <1ba2fa240908012249s348a2412wca21de44f9b8cb71@mail.gmail.com>
	 <1249199143.2007.2.camel@johannes.local>
	 <1ba2fa240908020343j7308e215vc1914244c8cd191a@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 02 Aug 2009 09:18:02 -0700
Message-Id: <1249229882.3491.33.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> > we don't have a GPS subsystem, but even without it, I think this is a
> >> > good thing to have.
> >>
> >> GPS devices are usually serial devices.
> >
> > Yeah, this is interesting -- do we want something like /dev/urfkill
> > (cf. /dev/uinput), so that gpsd or whatever is controlling the GPS (same
> > applies for 3G) can be controlled with rfkill?
> 
> Sorry don't know much about /dev/uinput what is difference between
> /dev/urfkill and /dev/rfkill, can you be, please more verbose

the uinput allows you to write a input driver in userspace. So with
urfkill you could in theory write a RFKILL switch as a userspace
program.

Regards

Marcel


