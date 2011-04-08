Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53890 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab1DHWL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 18:11:56 -0400
Received: by qwk3 with SMTP id 3so2352896qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 15:11:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1302299890.28673.1.camel@maggie>
References: <1302267632-2326-1-git-send-email-zajec5@gmail.com> <1302299890.28673.1.camel@maggie>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 9 Apr 2011 00:11:35 +0200
Message-ID: <BANLkTik_QTuAG+c7LnHt87_kKRy4HM6zvQ@mail.gmail.com>
Subject: Re: [PATCH][2.6.39?] b43: trivial: update module info about firmware
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
Cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/8 Michael Büsch <mb@bu3sch.de>:
> On Fri, 2011-04-08 at 15:00 +0200, Rafał Miłecki wrote:
>> We do not use ucode9,
>
> Well, but we should.
> There are only minor differences between r5 and r9 firmware.
> r9 basically is a r5 firmware with workarounds added that are
> needed for r9 devices.
>
> So I think we should start using r9 instead of removing it here.
>

With a fallback to r5 if no r9 firmware can be found... just to keep
OpenFWWF working.

> --
> Greetings Michael.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
