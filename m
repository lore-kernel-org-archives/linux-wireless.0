Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:7524 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbYGAKbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 06:31:06 -0400
Received: by nf-out-0910.google.com with SMTP id d3so568133nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 03:31:04 -0700 (PDT)
Message-ID: <f6ca9fed0807010331h7bfe33aame35873ffaa4181b0@mail.gmail.com> (sfid-20080701_123111_632701_D200EDE7)
Date: Tue, 1 Jul 2008 12:31:04 +0200
From: drago01 <drago01@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFC v3] b43: remove input device usage for rfkill
Cc: "Adel Gadllah" <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>,
	stefano.brivio@polimi.it,
	"Larry Finger" <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <1214907833.7763.38.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>
	 <1214906304.7763.34.camel@johannes.berg>
	 <6cf6b73e0807010305ne1c4b3bwb083c25953292f9d@mail.gmail.com>
	 <1214906908.7763.36.camel@johannes.berg>
	 <6cf6b73e0807010319x88f3624x83465cc314d8962f@mail.gmail.com>
	 <1214907833.7763.38.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 1, 2008 at 12:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> +     rfk->poll_timer->expires += round_jiffies(B43_RFKILL_POLL_DELAY);
>
> Umm, no. Can you please read the docs for round_jiffies?

did now, sorry for being stupid.
