Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:18595 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbZKHTSE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 14:18:04 -0500
Received: by ey-out-2122.google.com with SMTP id 25so41091eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 11:18:09 -0800 (PST)
To: "John Willis" <John.Willis@Distant-earth.com>
Cc: <me@bobcopeland.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] WL1251: Very crude EEPROM reading support for the WL1251 driver
References: <01c901ca4daf$6e3d7f20$4ab87d60$@Willis@Distant-earth.com>
	<871vk8g7z3.fsf@purkki.valot.fi>
	<006b01ca60a6$60aa1f80$21fe5e80$@Willis@Distant-earth.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 08 Nov 2009 21:18:07 +0200
In-Reply-To: <006b01ca60a6$60aa1f80$21fe5e80$@Willis@Distant-earth.com> (John Willis's message of "Sun\, 8 Nov 2009 19\:05\:01 -0000")
Message-ID: <87skcoesgg.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John Willis" <John.Willis@Distant-earth.com> writes:

>> Now I noticed that the Signed-off-by line is missing, can you please
>> send that also? A reply to this email is enough.
>
> The initial plan was for an RFC not a commit so I left off the signed off
> but as the patch has been reworked consider.

Actually it's a good idea to always include the signed off line, that
way anyone can freely work on the patch. Tagging the patch as RFC
should be enough to make it sure that it's not applied.

> Signed-off-by: David-John Willis <John.Willis@Distant-earth.com>

Thanks!

-- 
Kalle Valo
