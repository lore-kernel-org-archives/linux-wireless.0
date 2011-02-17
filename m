Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44310 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1BQWPU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:15:20 -0500
Received: by qwa26 with SMTP id 26so2816633qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Feb 2011 14:15:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297980018.13554.4.camel@maggie>
References: <AANLkTimKE+WqChVf0XpeHsfHxT8=3vbnBh=Lo+1tLSwj@mail.gmail.com>
	<1297894657.32237.2.camel@maggie>
	<AANLkTi=sVaeizU3xJQQwwKXB5saPgdn9VxNQv0-aoiV7@mail.gmail.com>
	<1297980018.13554.4.camel@maggie>
Date: Thu, 17 Feb 2011 23:15:18 +0100
Message-ID: <AANLkTi=FYOTt=8bMmH6W5Noeuifd-h9t8HEZB9ovg5ic@mail.gmail.com>
Subject: Re: [RFC] How to rename SSB_TMSLOW_*, B43_TMSLOW_*?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: George Kashperko <george@znau.edu.ua>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 17 lutego 2011 23:00 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> On Thu, 2011-02-17 at 13:14 +0100, Rafał Miłecki wrote:
>> That's why I wanted to introduce some SSBAI_CORECTL_FOOBAR and make
>> b43 unaware it that flags are going to be written in register A or B.
>> I wanted b43 to just pass flags to correct function and do not care
>> about place where they are getting written.
>
> Ok, well. That's basically what I am talking about for several
> days now.
>
> 1) Keep SSB and AI separated.
> 2) Introduce an additional thin layer on top of this to abstract the
> bus to the drivers.

OK, but how do you see core flags implemented in such a layout? The
ugly way I proposed seems to match your idea but... is ugly.

Can you say sth more about that? What about such a shared things that
differs in a minimal way?

-- 
Rafał
