Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53071 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbaDPLHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2014 07:07:36 -0400
Received: by mail-pd0-f179.google.com with SMTP id w10so10662290pde.10
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2014 04:07:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFED-j=o7nLGu4w3BTpxqkBwN5wTgwz5K7DVPurdRomDOCRApA@mail.gmail.com>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
 <1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com>
 <1393852248.10039.5.camel@jlt4.sipsolutions.net> <CANrMYP6Rvv4EBjY9-78bdm70G_3YGZFrJH9tFz5XVsbSSi-m=Q@mail.gmail.com>
 <CAB=NE6X02Apk8XFt7yomQKwNoENvKAy1QbGBknQUGJ2ZDs73Gw@mail.gmail.com>
 <CANrMYP4GhDZZzYkyyVCHKpb7YvJzNbFZn77hZH9T+y7HTQ4R=w@mail.gmail.com>
 <CAB=NE6UHKptAvbt1OM4O_cRiCj2wyEKGF2fFPsO_rQ0EUZQahA@mail.gmail.com>
 <CAFED-j=OAMJzFkjgCDx8YMHpEWfpZ6h4UQSRK7DQigrNuaOSig@mail.gmail.com>
 <CAB=NE6UGWfZxU6zi=XzLKWeN+1aFgxTVUpr349FVHBsRgSGo+A@mail.gmail.com>
 <CANrMYP7Meef9rt4aX_EeREq0z7uRtT6oSB6pjE3AqeHMx1GwJw@mail.gmail.com>
 <CA+XVXffzFWsJOU+PLWkeoce1+dDvrqruyi3_GG7V-6dfWpK7gA@mail.gmail.com>
 <CAB3XZEc6iXzEYcpYXEdYMQ0-yJxMbNvRGay3ezJX-yaXFksH9g@mail.gmail.com>
 <CANrMYP7QPoT-b_6GRWz6fOFeoO0c8LU09deRi3HFRB_wQJiUKQ@mail.gmail.com>
 <CA+XVXfdxZqLVe3_wT3pY-rdY_7KXz_iXFd7Z8JCfXrDwpP8ciQ@mail.gmail.com> <CAFED-j=o7nLGu4w3BTpxqkBwN5wTgwz5K7DVPurdRomDOCRApA@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 16 Apr 2014 14:07:21 +0300
Message-ID: <CA+XVXfdVg_PO-TKKTeTN-XWSi5vgx+VwYAr08Gui582oroeKAQ@mail.gmail.com> (sfid-20140416_130739_966356_C118330E)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non modular
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Colleen T <colleen@cozybit.com>, Eliad Peller <eliad@wizery.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sander Eikelenboom <linux@eikelenboom.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 16, 2014 at 2:01 PM, Janusz Dziedzic
<janusz.dziedzic@gmail.com> wrote:
> 2014-04-16 12:38 GMT+02:00 Arik Nemtsov <arik@wizery.com>:
>> Thanks for testing Colleen!
>>
>> I'll respin the patch on top of wireless-testing.
>>
> Please don't remove "Pending regulatory reques ... " dbg print. This
> could be usefull for debuging.

Well that's a comment for Luis I guess. Removing the print is not
really part of my patch.

Arik
