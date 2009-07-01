Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33238 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZGAUki (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 16:40:38 -0400
Received: by fxm18 with SMTP id 18so1071071fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2009 13:40:39 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dave <kilroyd@googlemail.com>,
	Karl Relton <karllinuxtest.relton@ntlworld.com>,
	dwmw2@infradead.org, linux-wireless@vger.kernel.org
Subject: Re: Insist on cfg80211 for new drivers?
References: <1246388712.4949.52.camel@localhost>
	<43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>
	<1246396179.4949.76.camel@localhost>
	<43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com>
	<1246464991.4331.18.camel@localhost> <4A4BA21F.1070101@gmail.com>
	<43e72e890907011112l220874bbu8db8808f666bbd4d@mail.gmail.com>
	<1246473300.30522.10.camel@localhost.localdomain>
	<20090701193657.GD3473@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 01 Jul 2009 23:40:37 +0300
In-Reply-To: <20090701193657.GD3473@tuxdriver.com> (John W. Linville's message of "Wed\, 1 Jul 2009 15\:36\:57 -0400")
Message-ID: <87ljn8t9ve.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> On Wed, Jul 01, 2009 at 02:35:00PM -0400, Dan Williams wrote:
>
>> That's really all I
>> care about, I don't want another WEXT-based driver accepted; I want all
>> the new ones using cfg80211.
>
> Now there is a discussion we should have had in Berlin...

Yes, we missed this one.

> is it time to insist on cfg80211-based configuration for all new
> drivers?

I vote for yes. In my books wext is depreceated and its use should be
avoided. After Johannes' excellent work we need to start pushing the use
of cfg80211 and nl80211.

-- 
Kalle Valo
