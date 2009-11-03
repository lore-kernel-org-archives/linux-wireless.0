Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46689 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbZKCM6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 07:58:38 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Date: Tue, 3 Nov 2009 13:58:18 +0100
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	Dan Williams <dcbw@redhat.com>,
	Frank Schaefer <schaefer.frank@gmx.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
References: <200910171606.02961.oliver@neukum.org> <20091102211123.GI24436@one-eyed-alien.net> <200911031157.23165.oliver@neukum.org>
In-Reply-To: <200911031157.23165.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200911031358.19012.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 03 November 2009 11:57:22 Oliver Neukum wrote:
> Am Montag, 2. November 2009 22:11:23 schrieb Matthew Dharm:
> > It's worth noting that for some of these which are handled in-kernel, it
> > had to be done that way because their storage-emulation was so poor that
> > the normal 'eject' WOULD NOT work properly.
> >
> > Any device which can be handled in userspace SHOULD be handled there.
> 
> Do these devices survive a reset and stay in the correct mode?
> Has that been tested?

ar9170usb does an usb reset right before it uploads the WLAN firmware.
The device stays in the correct mode, else it wouldn't be possible
to continue because usb-storage mode has a different PID.

Regards,
	Chr
