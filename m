Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56279 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab1CRQEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 12:04:37 -0400
Received: by qyg14 with SMTP id 14so3514200qyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 09:04:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300463925.13499.118.camel@dev.znau.edu.ua>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	<1300453433.13499.18.camel@dev.znau.edu.ua>
	<AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
	<1300460342.13499.60.camel@dev.znau.edu.ua>
	<AANLkTi=2qBhKfJZ8a2GEgx_4aJL_85FKODUX31BddmN1@mail.gmail.com>
	<1300463925.13499.118.camel@dev.znau.edu.ua>
Date: Fri, 18 Mar 2011 17:04:36 +0100
Message-ID: <AANLkTikGpQG1PS+VoX-8pZwePci08NO4RHjjLn+Lshg5@mail.gmail.com>
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/18 George Kashperko <george@znau.edu.ua>:
> My english is awful therefore seems we missunderstood each other. I'm
> sure I got your point right - you plan to start up the new (bcmb)
> project for both sb and ai support.

No, no, no. My bcmb is not expected to be project for both buses. It
is expected to provide helper functions for *two separated* drivers:
ai and ssb.

I don't want to duplicate ssb_core_name (already implemented in ssb)
in my ai. That way I put it in bcmb_scan.c. I can now use
ssb_core_name in both: ssb and ai without double, duplicated
implementation.

I'm still reading your earlier e-mail...

-- 
Rafał
