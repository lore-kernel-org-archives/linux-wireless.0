Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41298 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab1DHHms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 03:42:48 -0400
Received: by qyg14 with SMTP id 14so2302932qyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 00:42:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D9E316E.4000908@lwfinger.net>
References: <4D9E316E.4000908@lwfinger.net>
Date: Fri, 8 Apr 2011 09:42:47 +0200
Message-ID: <BANLkTik+XBR65AThzFGf6Ug2LQXo88ju=Q@mail.gmail.com>
Subject: Re: Questions about rt2800usb
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jett Chen <jett_chen@ralinktech.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I know from experience that the staging driver rt82860sta has been replaced
> by rt2800pci and I plan to push a patch deleting the driver from staging.

Excellent! :)

> It appears that rt2870sta has been replaced by rt2800usb. Is that correct?
> If so, I will also include the deletion of that driver from staging in the
> patch.

Yeah, rt2800usb is the rt2x00 version of rt2870sta.

> I noticed that rt2870sta includes a few USB IDs not found in rt2800usb,
> namely:
>
> 0x2001:0x3c09, 0x2001:0x3c0a, and 0x2019:0xed14.
>
> Any reasons why these should not be included in rt2800usb?

Nope, could you post a patch to add them?

> Please let me know of any objections to removing those two staging drivers.

I would definately welcome the removal of the staging drivers.

Ivo
