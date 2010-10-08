Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60034 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630Ab0JHR1X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 13:27:23 -0400
Message-ID: <4CAF5488.3030706@Atheros.com>
Date: Fri, 8 Oct 2010 22:57:36 +0530
From: Suraj Sumangala <suraj@Atheros.com>
MIME-Version: 1.0
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Suraj Sumangala <Suraj.Sumangala@Atheros.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Firmware versioning best practices: ath3k-2.fw rename or replace
 ath3k-1.fw ?
References: <20101008170258.GJ10149@tux>
In-Reply-To: <20101008170258.GJ10149@tux>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

On 10/8/2010 10:32 PM, Luis Rodriguez wrote:
> Suraj,
>
> What is the difference between ath3k-2.fw and ath3k-1.fw ?

This is the same question for which I have been trying to get an answer.
The only information that I got was it fixes some critical bug and 
support shared antenna.

If ath3k-2.fw is an upgrade of ath3k-1.fw why do we need to name it 
differently?

>
> Won't the API change now that you are addressing the sflash
> configuration fix? Would it not help to identify the two
> different firmwares then?
>
> David, Marcel, what are your preferences for a firmware upgrade
> where the firmware does not change API (lets just pretend it does
> not for a moment) ? Do we keep the same filename?

Marcel had answered me before. It makes sense to have same file name.
Other ways we end up changing the driver whenever there is a firmware 
change.

>
> In this particular case I would assume our new sflash configuration
> fix that might be being worked on might change the re-enumerated
> USB device IDs so it seems to me a good idea to use a new filename.
> I should note ath3k-2.fw already made it to linux-firmware.git...
>
> I last tried to document a thread we had over this here:
>
> http://wireless.kernel.org/en/developers/Documentation/firmware-versioning
>
> Does this sound sane? If so then the sflash configuration fix
> would seem to me like it would require a new filename. Now, while
> we're at it, how about bug fixes?
>
> Suraj -- keep these discussions public please....
>
>    Luis

Regards
Suraj

