Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:57310 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbZBLOiP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 09:38:15 -0500
Received: by ey-out-2122.google.com with SMTP id 25so87720eya.37
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 06:38:13 -0800 (PST)
Date: Thu, 12 Feb 2009 15:33:48 +0100
From: "Christoph .J Thompson" <cjsthompson@gmail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Sitecom WL-608 USB WiFi
Message-Id: <20090212153348.e69a7508.cjsthompson@gmail.com> (sfid-20090212_153820_052594_1B2ED928)
In-Reply-To: <a32f33a40902120040odc535cp3ecdeef3bc9565ab@mail.gmail.com>
References: <20090211211707.d5e71ddb.cjsthompson@gmail.com>
	<200902112332.53480.IvDoorn@gmail.com>
	<3ace41890902111451n6c9cbdc4me410609479b1ac4f@mail.gmail.com>
	<20090212042217.b05e83b4.cjsthompson@gmail.com>
	<a32f33a40902120000g1e95df1eq8a221ddc539f351c@mail.gmail.com>
	<20090212092658.1ad4bb08.cjsthompson@gmail.com>
	<a32f33a40902120040odc535cp3ecdeef3bc9565ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 Feb 2009 09:40:22 +0100
Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> As far as I know the rt2870 driver provided by Ralink contains support
> for Master mode, and it should even cooperate with hostapd. Not sure
> if anybody has tested that yet. But you could give it a try.

I've looked at the RaLink 1.4.0.0 driver for the rt2870usb available on RaLink's
website and there is only station mode support. Maybe I'm missing something and
there is a fork or older driver with AP support?

> Otherwise
> you can check rt2x00.git to see if the rt2800usb driver can send out
> beacons correctly. So far I have only tested managed mode and that
> worked reasonable (if you ignore the lack of 11n AP scan results, and
> some startup kickups). Note that you should use the module parameter
> nohwcrypt for rt2800usb to disable HW crypto.

I think I'll have to resort to that. Sorry if the question is stupid, but
what version of the kernel is in rt2x00.git? Can I backport the changes
to 2.6.28.4 by making a diff between rt2x00.git's drivers/net/wireless
and 2.6.28.4's drivers/net/wireless directory?

-- 
Christoph .J Thompson <cjsthompson@gmail.com>
