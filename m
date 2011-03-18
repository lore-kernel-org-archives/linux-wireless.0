Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55908 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab1CROKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:10:40 -0400
Received: by qwk3 with SMTP id 3so2833074qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:10:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300453433.13499.18.camel@dev.znau.edu.ua>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	<1300453433.13499.18.camel@dev.znau.edu.ua>
Date: Fri, 18 Mar 2011 15:10:39 +0100
Message-ID: <AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
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
> Current ssb code ideology isn't really good place to start with support
> for ai backplanes. Its really great to see you willing to get ai
> supported in mainline but I'm sure this should be done apart from the
> ssb code and not even with one as the design decisions origin. Several
> concepts the ssb is based on are not designed to support anything else
> than ocp/sb and will require workarounds to suport ai.
> Thanks to Michael I had a time to think over the possibly code
> abstraction for shared sb and ai support. And while I'm still sure the
> patchwork for ai over ssb support is of good use as some intermediate
> decision to support ai-based hardware in sertain distributions but now I
> support Michael in that such (hopefully) a temporary buildups should not
> be in mainline.

Please, give some concrete arguments, which part of design does not match AI.

My patch has shown we need to duplicate 40% of SSB's scanning code.
What for example about pci.c? Which functions from that file won't be
duplicated in totally separated?

-- 
Rafał
