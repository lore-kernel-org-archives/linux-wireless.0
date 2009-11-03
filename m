Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:37248 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZKCLCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 06:02:51 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Date: Tue, 3 Nov 2009 11:57:22 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	Frank Schaefer <schaefer.frank@gmx.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
References: <200910171606.02961.oliver@neukum.org> <1257193115.1027.24.camel@localhost.localdomain> <20091102211123.GI24436@one-eyed-alien.net>
In-Reply-To: <20091102211123.GI24436@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911031157.23165.oliver@neukum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 2. November 2009 22:11:23 schrieb Matthew Dharm:
> It's worth noting that for some of these which are handled in-kernel, it
> had to be done that way because their storage-emulation was so poor that
> the normal 'eject' WOULD NOT work properly.
>
> Any device which can be handled in userspace SHOULD be handled there.

Do these devices survive a reset and stay in the correct mode?
Has that been tested?

	Regards
		Oliver

