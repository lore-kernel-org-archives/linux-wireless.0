Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4623 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab1KURXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 12:23:31 -0500
Message-ID: <4ECA8908.7070304@broadcom.com> (sfid-20111121_182341_140044_BF76D357)
Date: Mon, 21 Nov 2011 18:23:20 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Lang=E5s?= <thomas.langas@fxitech.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: brcm80211 (with bcm4329-chip)
References: <CADrAYBnwWEaigcgQYYk6V3VEuEYyrmzJQXegKVk6TgOTPh5N8A@mail.gmail.com>
In-Reply-To: <CADrAYBnwWEaigcgQYYk6V3VEuEYyrmzJQXegKVk6TgOTPh5N8A@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2011 02:56 PM, Thomas Langås wrote:
> Hi!
> 
> I'm trying to make our board use this driver instead of an old,
> proprietary bcm4329-driver, but I can't seem
> to find much detail on how to tell the driver where my chip is located
> (on what SDIO-bus).  I suppose there
> is some specifics I need to include in my machine-file?  Or is
> everything magic?  Because, currently
> the platform crashes when enabling the driver. I suspect that this is
> because we boot from an uSD-card,
> and that the brcm80211 tries to access the same port for connecting to the chip.
> 

The MMC core should be able to come up with the correct device. It
sounds strange that the driver would be activated for an SD card.

Could you provide some information on the board you are using. Type of
processor, kernel version, and anything else you can/want to share. In
/sys/bus/sdio/devices/ you may find the location of the bcm4329.

Gr. AvS

