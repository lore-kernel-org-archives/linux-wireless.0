Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34177 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934219AbcA0S1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 13:27:30 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ksenija =?utf-8?Q?Stanojevi=C4=87?=
	<ksenija.stanojevic@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org
Subject: Re: Move wlan-ng out of staging?
References: <CAL7P5j+iYzpnR+xT013A7AV=bQ8bSn4W1K=qjieFCAiv1YmwRw@mail.gmail.com>
	<20160125181220.GJ5325@mwanda>
Date: Wed, 27 Jan 2016 20:27:18 +0200
In-Reply-To: <20160125181220.GJ5325@mwanda> (Dan Carpenter's message of "Mon,
	25 Jan 2016 21:12:20 +0300")
Message-ID: <87r3h2ubcp.fsf@purkki.adurom.net> (sfid-20160127_192748_856358_6577D436)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> On Mon, Jan 25, 2016 at 01:16:56PM +0100, Ksenija Stanojević wrote:
>> Hi All,
>> 
>> I'm helping Greg do a bit of cleanup in the staging tree, I noticed that
>> wlan-ng driver is maybe ready to be moved out of staging. Are there
>> any TODO tasks left to do beside checkpatch.pl clean-up?

For questions like this you should CC linux-wireless.

> I happened to look through this code recently.  It's terrible.

And uses wireless extensions, yuck. There's a lot of work to get it into
reasonable shape, fixing checkpatch warnings will not be enough.

-- 
Kalle Valo
