Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49455 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab1CHHju (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 02:39:50 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 17/18] wl1251: enable tx path in monitor mode if necessary for packet injection
References: <4D45A79A.1030102@davizone.at> <4D45B7DC.3060303@davizone.at>
	<8762t5dptt.fsf@purkki.adurom.net> <4D473F16.4010102@davizone.at>
	<87bp2vbcem.fsf@purkki.adurom.net> <4D5EDE0E.9060004@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 08 Mar 2011 09:39:48 +0200
In-Reply-To: <4D5EDE0E.9060004@davizone.at> (David Gnedt's message of "Fri\, 18 Feb 2011 22\:01\:02 +0100")
Message-ID: <87sjuy2h8b.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> Am 2011-02-01 23:47, schrieb Kalle Valo:
>> What frames are we talking about exactly? (I can't test this right now.)
>
> They look to me like CTS-to-Self frames. I have attached a sample of
> them. There is no other RTS/CTS traffic on the same channel.

IIRC correctly bluetooth coexistance sends CTS-to-Self frames before
firmware is giving airtime to bluetooth. I'm guessing that's the
reason why you are seeing these frames.

-- 
Kalle Valo
