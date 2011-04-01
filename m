Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64185 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075Ab1DAQGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 12:06:17 -0400
Received: by ewy4 with SMTP id 4so1101065ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 09:06:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301673646.5219.18.camel@maggie>
References: <AANLkTikGp+ZFhTtsaW7E4SO_5trte1_eF4KLWbkwVty5@mail.gmail.com>
	<1301673646.5219.18.camel@maggie>
Date: Fri, 1 Apr 2011 18:06:16 +0200
Message-ID: <BANLkTin2ZaBVbum9Y=iqWTwW4kzkdKAJnA@mail.gmail.com>
Subject: Re: ChipCommon as independent driver?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 1 kwietnia 2011 18:00 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> On Fri, 2011-04-01 at 16:49 +0200, Rafał Miłecki wrote:
>> Do you have idea how we could nicely solve that issue?
>
> Yeah. Just don't share code between ssb and bcmai.
> That's the only clean solution to that mess.

Do you want to have core drivers separated as well? Really? Should we
have separated pci core? chiccommon core? gige core? 80211 (b43) core?

My mistake was to include ssb_private.h in separated chipcommon.

-- 
Rafał
