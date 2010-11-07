Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58962 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab0KGKUK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Nov 2010 05:20:10 -0500
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/3] wl1251: add runtime PM support for SDIO
References: <1288822429-24541-1-git-send-email-notasas@gmail.com>
	<1288822429-24541-3-git-send-email-notasas@gmail.com>
	<AANLkTimfXO9r=DTW3CAiVswmsoKES2qxEiYz4JBOTGu_@mail.gmail.com>
	<AANLkTik0tawXfer2DMSKFXZwFbjYWLoG3nRBYMAMO8WL@mail.gmail.com>
	<AANLkTimtryH0HTWk0ymK6EY1XcCPv6eLDYM-GzuJxhEy@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 07 Nov 2010 12:20:09 +0200
In-Reply-To: <AANLkTimtryH0HTWk0ymK6EY1XcCPv6eLDYM-GzuJxhEy@mail.gmail.com> (Ohad Ben-Cohen's message of "Thu\, 4 Nov 2010 18\:04\:58 -0400")
Message-ID: <878w15zb8m.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ohad Ben-Cohen <ohad@wizery.com> writes:

>>> Why do you still need that ->set_power() handler ?
>>
>> On pandora besides power, we also have a GPIO to control clock buffer
>> for wl1251, so I thought I could enable it here.
>
> Oh, I see. The name set_power then is a bit misleading.. ;)

Maybe a comment stating the reason for the callback would make it more
clear?

-- 
Kalle Valo
