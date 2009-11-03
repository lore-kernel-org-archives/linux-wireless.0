Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:37198 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZKCLCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 06:02:44 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices in cdrom mode
Date: Tue, 3 Nov 2009 11:55:05 +0100
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	Frank Schaefer <schaefer.frank@gmx.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
References: <200910171606.02961.oliver@neukum.org> <20091102211123.GI24436@one-eyed-alien.net> <1257198124.1027.63.camel@localhost.localdomain>
In-Reply-To: <1257198124.1027.63.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911031155.06400.oliver@neukum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 2. November 2009 22:42:04 schrieb Dan Williams:
> The kernel drivers know which devices are supported and how to drive
> them.  But because the eject code isn't in kernelspace, all that device
> selection logic has to be duplicated in userspace with usb_modeswitch.
> Pretty dumb.

No, the kernel doesn't have to know which devices need a mode switch.
Nor does user space need to know which driver a device needs to switch its
mode.

	Regards
		Oliver

