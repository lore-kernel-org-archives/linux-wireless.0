Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:45745 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZKCQ1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 11:27:05 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Date: Tue, 3 Nov 2009 17:29:25 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	Frank Schaefer <schaefer.frank@gmx.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0911031001470.10778-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911031001470.10778-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911031729.26463.oliver@neukum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 3. November 2009 16:16:12 schrieb Alan Stern:
> This sounds as if you are trying very hard to get the _worst_ of both
> worlds!  You would force users to upgrade their kernels before they can
> use new devices (because the kernel is where the mode-switch code will
> be), and you also would force them to upgrade their userspace settings
> (so that the new mode-switch code will be called).

Yes.

> I'm with Matt Dharm and Josua Dietze on this.  Jobs that can be handled
> in userspace _should_ be handled there.

There is the inconvenient problem of hibernation. And, if more systems
start cutting power to USB in STR, the problem of STR. I am inclined
to declare that hibernation is a problem of those pesky misdesigns.
But dare we say that also about STR?

	Regards
		Oliver

