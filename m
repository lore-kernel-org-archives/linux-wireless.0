Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58601 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab1HSVSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 17:18:35 -0400
Received: by pzk37 with SMTP id 37so5459213pzk.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2011 14:18:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313787142.6210.9.camel@shinybook.infradead.org>
References: <4E3420E9.6080603@lwfinger.net>
	<CACna6ryErHY+OyAnvc9+MYArb5mXpSdadOPADsQOBz796UqSUw@mail.gmail.com>
	<1313617419.3990.134.camel@shinybook.infradead.org>
	<CACna6rzQmEE-EF+7tvQ8vkwp9bYwWMkna3UHw8ym7PmjKWWQTQ@mail.gmail.com>
	<1313653897.13224.4.camel@shinybook.infradead.org>
	<CACna6rzsKaHYL4aH9=0X+_6Q7j-_5AnHc7KfiQ9_FxSLhqEPBA@mail.gmail.com>
	<1313787142.6210.9.camel@shinybook.infradead.org>
Date: Fri, 19 Aug 2011 23:17:48 +0200
Message-ID: <CACna6ryuTmzo2COBZ9+o-=7AOhLm3ZPebHL+rbGiXN+w94WQYQ@mail.gmail.com> (sfid-20110819_231838_745313_3B42B3B1)
Subject: Re: [PATCH] Add uevent to bcma bus, to autoload drivers.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 19 sierpnia 2011 22:52 użytkownik David Woodhouse
<dwmw2@infradead.org> napisał:
> On Fri, 2011-08-19 at 22:13 +0200, Rafał Miłecki wrote:
>> I can accept sending patch directly to John, if I'm included in CC and
>> linux-wireless is included as well.
>
> But if b43 isn't ready for *some* bcma card, so you don't want it
> autoloading, then perhaps we might have wanted to remove a MODULE_ALIAS
> from b43 to prevent it being autoloaded for just *that* device. Or
> something like that. So even for this "obviously correct" patch I'd
> rather run it by you first.

There is nothing wrong in auto-loading b43 for unsupported card. b43
will detect the PHY type is not supported and will return false from
probing function.

-- 
Rafał
