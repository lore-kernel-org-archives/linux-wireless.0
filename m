Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:56447 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbZKDQjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 11:39:11 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Date: Wed, 4 Nov 2009 17:41:31 +0100
Cc: Frank Schaefer <schaefer.frank@gmx.net>,
	USB list <linux-usb@vger.kernel.org>,
	linux-wireless@vger.kernel.org
References: <Pine.LNX.4.44L0.0911041036100.2968-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911041036100.2968-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911041741.32128.oliver@neukum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 4. November 2009 17:16:18 schrieb Alan Stern:
> The only exception would be the case that Oliver is worried about,
> where a device loses its mode setting during a reset or system sleep.  
> In principle the kernel could put it back in the correct mode while
> keeping the device's identity intact (although the code to do this
> would be extremely ugly, and convincing people to allow it would be

Oh yes.

> hard).  Even then, I don't see how existing serial/phone connections
> could be maintained across a reset, so there might not be any point.

I am afraid this will spread beyond modems.
For now I'd like those devices which are affected by resets to get
a quirk that marks them as not resettable for purposes of error handling.
But I fear we may have to face this system in the future on a regular
basis.

	Regards
		Oliver

