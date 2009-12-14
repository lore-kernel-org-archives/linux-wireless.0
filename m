Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50441 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZLNG3G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 01:29:06 -0500
Received: by ewy19 with SMTP id 19so3044291ewy.21
        for <linux-wireless@vger.kernel.org>; Sun, 13 Dec 2009 22:29:05 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: cfg80211 connect for at76c50x-usb
References: <c4d76b3b0912071955y25c31a11m104d9c4723ef578d@mail.gmail.com>
	<87ws0x3ojk.fsf@purkki.valot.fi>
	<c4d76b3b0912081947m2ffcdb65of44f4ce10dfa00d2@mail.gmail.com>
	<87skbk35tx.fsf@purkki.valot.fi>
	<c4d76b3b0912091454o383ff350mce78d69565a1530c@mail.gmail.com>
	<c4d76b3b0912131945q64a6bc83r89c0bb851e962c98@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 14 Dec 2009 08:29:03 +0200
In-Reply-To: <c4d76b3b0912131945q64a6bc83r89c0bb851e962c98@mail.gmail.com> (Jason Andryuk's message of "Sun\, 13 Dec 2009 22\:45\:57 -0500")
Message-ID: <87tyvuyspc.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> On Wed, Dec 9, 2009 at 5:54 PM, Jason Andryuk <jandryuk@gmail.com> wrote:
>> A quick test under OpenBSD doesn't show any transmitted packets on the
>> monitor interface either and the device doesn't connect to the AP.
>> Makes me more suspicious of the device having failed.
>
> Going back to 2.6.31 and using the staging driver still works.

Good to hear that the hardware still works.

> I am not sure it matters, but the previous hack attempt did not set
> the WEP key.  I also noticed a couple of differences with CMD_STARTUP
> between at76_usb and at76c50x-usb.  I have not fully investigated the
> differences at this time, but I plan to do so as time permits.

Great that you can work on this, thank you for that.

-- 
Kalle Valo
