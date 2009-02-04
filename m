Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:35762 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbZBDIQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 03:16:19 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Jason Andryuk <jandryuk@gmail.com>
Subject: Re: at76_usb development
Date: Wed, 4 Feb 2009 09:17:12 +0100
Cc: gregkh@suse.de, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, kalle.valo@iki.fi, milan.plzik@gmail.com
References: <c4d76b3b0902032005m3847235cu42f963ca6ad796af@mail.gmail.com>
In-Reply-To: <c4d76b3b0902032005m3847235cu42f963ca6ad796af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902040917.14343.oliver@neukum.org> (sfid-20090204_091626_339536_A675895E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Wednesday 04 February 2009 05:05:04 schrieb Jason Andryuk:
> Where should development on at76_usb take place?
[..]
> I have more or less tracked down an Oops on disconnect with the
> wireless-testing version.  Hopefully the time spent has been
> worthwhile.
> 
> Let me know,

This is an important question. We cannot develop against widely
diverging versions. If the driver is changed a lot, development must happen
against the kernel version or it should be removed from the kernel.

	Regards
		Oliver
 
