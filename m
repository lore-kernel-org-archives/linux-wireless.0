Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33149 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbcA0Wsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 17:48:36 -0500
MIME-Version: 1.0
In-Reply-To: <87r3h2ubcp.fsf@purkki.adurom.net>
References: <CAL7P5j+iYzpnR+xT013A7AV=bQ8bSn4W1K=qjieFCAiv1YmwRw@mail.gmail.com>
 <20160125181220.GJ5325@mwanda> <87r3h2ubcp.fsf@purkki.adurom.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 28 Jan 2016 09:48:16 +1100
Message-ID: <CAGRGNgVzbBGBOko-YG7h7rX+ZZHeKa5XHM3x+zdqz9mHX7nfRg@mail.gmail.com> (sfid-20160127_234851_160349_F9397A6B)
Subject: Re: Move wlan-ng out of staging?
To: Glen Lee <glen.lee@atmel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	=?UTF-8?Q?Ksenija_Stanojevi=C4=87?= <ksenija.stanojevic@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Glen,

On Thu, Jan 28, 2016 at 5:27 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
>
>> On Mon, Jan 25, 2016 at 01:16:56PM +0100, Ksenija Stanojević wrote:
>>> Hi All,
>>>
>>> I'm helping Greg do a bit of cleanup in the staging tree, I noticed that
>>> wlan-ng driver is maybe ready to be moved out of staging. Are there
>>> any TODO tasks left to do beside checkpatch.pl clean-up?
>
> For questions like this you should CC linux-wireless.
>
>> I happened to look through this code recently.  It's terrible.
>
> And uses wireless extensions, yuck. There's a lot of work to get it into
> reasonable shape, fixing checkpatch warnings will not be enough.

On the same subject, the wilc1000 driver has taken some pretty big
steps in the past few days, how far away do you think it is from
graduating from staging?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
