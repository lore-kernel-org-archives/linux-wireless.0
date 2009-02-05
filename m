Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:20009 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZBED5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 22:57:32 -0500
Received: by yx-out-2324.google.com with SMTP id 8so15147yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 19:57:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <da94abde0902040748l6194cdd3i7044c839f3110e5a@mail.gmail.com>
References: <c4d76b3b0902032005m3847235cu42f963ca6ad796af@mail.gmail.com>
	 <200902040917.14343.oliver@neukum.org>
	 <20090204144317.GA3845@tuxdriver.com>
	 <da94abde0902040748l6194cdd3i7044c839f3110e5a@mail.gmail.com>
Date: Wed, 4 Feb 2009 22:57:30 -0500
Message-ID: <c4d76b3b0902041957o6e8fd468rffcd63e14a5cbf1d@mail.gmail.com> (sfid-20090205_045749_558729_B2C6DF09)
Subject: Re: at76_usb development
From: Jason Andryuk <jandryuk@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Oliver Neukum <oliver@neukum.org>, gregkh@suse.de,
	linux-wireless@vger.kernel.org, milan.plzik@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 4, 2009 at 10:48 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Hopefully I'll send a first version of at76c50-usb soon. Sorry for
> taking it so long.
>
> It's nice to see interest for at76_usb, though. I was sure that nobody
> uses it anymore.

Ok, the future is at76c50x-usb.  Kalle, I'd like to see the driver as
soon as possible since working on the staging version seems rather
pointless.

I did track down an oops related to workqueues on at76_usb + mac80211.
 I can send that out, but it isn't relevant to the old at76_usb in
staging.

I'd like to help so that my at76c503-i3861 adapter just works if I
need it in the future.

Jason
