Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:53849 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYLUMIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 07:08:05 -0500
Received: by ewy10 with SMTP id 10so1791147ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2008 04:08:01 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 8/15] rt2x00: Implement WDS support
Date: Sun, 21 Dec 2008 13:07:57 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201057.02583.IvDoorn@gmail.com> <1229855824.4953.10.camel@johannes>
In-Reply-To: <1229855824.4953.10.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200812211307.57756.IvDoorn@gmail.com> (sfid-20081221_130809_841422_7A82480A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 21 December 2008, Johannes Berg wrote:
> On Sat, 2008-12-20 at 10:57 +0100, Ivo van Doorn wrote:
> > WDS support should be very easy to handle, mac80211 handles
> > everything for us, so all that is needed is to set the
> > support flags and handle it in the add_interface() callback.
> 
> Cool, you're the first, have you tested?

Unfortunately neither Meshed mode as WDS have been tested,
I understood Meshed mode had worked some time ago on rt73usb,
but now beaconing is broken (master mode isn't working either anymore).

btw, rt2x00 wasn't the first, I looked at the b43 code to see if they had do
anything special in WDS mode. ;)

Ivo
