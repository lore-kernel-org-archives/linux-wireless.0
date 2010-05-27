Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:33523 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab0E0SbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 14:31:17 -0400
Received: by qyk13 with SMTP id 13so397166qyk.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 11:31:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilPvGLRhwZBY3q9UXLaq-zbI9U-VhFNx1dfq1mH@mail.gmail.com>
References: <AANLkTimltZSc8dJPPBCibcGDaOPcQRU_5kSbenIAdi_6@mail.gmail.com>
	<AANLkTimaLEQYH4Y7HO4Fv4zT8w8AsPkaAQtk9EauX4Bt@mail.gmail.com>
	<AANLkTikRt1fUgngBQxEoEFe1VDrYVFRAoMSR53et7gxf@mail.gmail.com>
	<AANLkTim-A_TWT-flrW88gJGan47Xhm7llyrQE3ehDKU6@mail.gmail.com>
	<AANLkTim4zLxIQH2r76WZRh9kNigVNAngcK1d9-Cu65Ag@mail.gmail.com>
	<AANLkTimH3p-dBA_6ee2a0iCnPDhtPZONzCEVkzMHrUWo@mail.gmail.com>
	<AANLkTim-4UNn8acYvF7AF2FDzdC9xRY-9JS0lSurwBc6@mail.gmail.com>
	<AANLkTimYeL4KQozuTl4le9WUpObsjwp0YAx7eAYq6MBr@mail.gmail.com>
	<AANLkTikOgv6d0FlXu2-smnYPApeehjRq_j8UxEealqFC@mail.gmail.com>
	<AANLkTinynNqs6_zyTJcpi7yKiSvC5fBhbM2tVZcnoNUq@mail.gmail.com>
	<AANLkTinyGlwqq4xshLU5Ol74p0VfcUXBjBGKXlsB2pMy@mail.gmail.com>
	<AANLkTimIeTadyAhUuri2P630mpDwmBk4B90RpERLbaFE@mail.gmail.com>
	<AANLkTilXJHs8emXX4YNHbPq0SkuC4Z22NEh-T6mwUSHS@mail.gmail.com>
	<4BFDEBDC.4070304@gmail.com>
	<AANLkTin3VSp_FcSiadD4efE1Yo1vKiDXmOngsHEKiQmF@mail.gmail.com>
	<AANLkTilPvGLRhwZBY3q9UXLaq-zbI9U-VhFNx1dfq1mH@mail.gmail.com>
Date: Thu, 27 May 2010 14:31:12 -0400
Message-ID: <AANLkTil5yP2xZ5sBXmDEVCHvD2oim92R-dfHx6f-pLOS@mail.gmail.com>
Subject: Re: ath5k past 2.6.30 breaks monitor mode (and thus the aircrack
	suite)
From: Bob Copeland <me@bobcopeland.com>
To: Weedy <weedy2887@gmail.com>
Cc: Richard Farina <sidhayn@gmail.com>,
	=?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 27, 2010 at 1:40 PM, Weedy <weedy2887@gmail.com> wrote:

>> Weedy, if you want reported-by credit can you give your full name and
>> preferred email address?
> Do I have to? I don't really want to tie my name to this email :/

Honestly I don't know what reported-by policy is (other than I should
get your consent first).  I guess John can weigh in whether:

   Reported-by: weedy2887@gmail.com

is acceptable.  For S-o-b, the rule is no anonymous or pseudonymous
contributions.  Of course, you don't have to be credited, but your
bisection was a huge help in pinning it down :)

-- 
Bob Copeland %% www.bobcopeland.com
