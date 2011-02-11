Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout09.t-online.de ([194.25.134.84]:53991 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1BKNbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 08:31:51 -0500
Message-ID: <4D553A37.5030504@t-online.de>
Date: Fri, 11 Feb 2011 14:31:35 +0100
From: =?ISO-8859-1?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [RFC] ath9k: Fix ath9k prevents CPU to enter C3 states
References: <1297262007-15128-1-git-send-email-mshajakhan@atheros.com> <4D52C54A.2010709@t-online.de> <4D53F3DE.4030707@atheros.com> <20110210174127.GA16737@tux> <4D542404.5050004@t-online.de>
In-Reply-To: <4D542404.5050004@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Richard, can you test the userspace app as a replacement? Or did your board not
>> exerpience the issue?
>
> I was unaffected. Therefore I was unhappy with losing my C-states for no good reason.
>

Nevertheless I tested the userspace approach now. It disables the C4-state on my machine,
so it should also help those who really have problems with the performance of their
wireless connection.

-- 
Regards,
Richard Schütz
