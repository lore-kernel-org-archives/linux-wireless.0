Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:47466 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYJEGWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 02:22:37 -0400
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, proski@gnu.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: at76_usb driver status
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com>
	<1223187189.11272.74.camel@violet.holtmann.net>
From: Kalle Valo <Kalle.Valo@iki.fi>
Date: Sun, 05 Oct 2008 09:22:29 +0300
In-Reply-To: <1223187189.11272.74.camel@violet.holtmann.net> (Marcel Holtmann's message of "Sun\, 05 Oct 2008 08\:13\:09 +0200")
Message-ID: <87hc7rsgre.fsf@litku.valot.fi> (sfid-20081005_082240_690956_641FD6E7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel Holtmann <holtmann@linux.intel.com> writes:

> Hi Kalle,

Hello Marcel,

>> I might be interested in getting DFU into USB core, because I would
>> like to learn more about USB. But first I need to get at76_usb stable.
>
> please be careful with this. I have seen so many broken or vendor
> enhanced DFU stuff that it might be not a good idea to put it into the
> USB core since it would be full of quirks.

Heh, I should have guessed this. Thanks for the heads up. 

> I do have my own dfutool used for firmware flashing and the OpenMoko
> project got their own dfu-util. Both in userspace.

Thanks, I'll take a look at them.

-- 
Kalle Valo
