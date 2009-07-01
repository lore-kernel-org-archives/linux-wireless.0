Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:42444 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZGATtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:49:50 -0400
Received: by yxe26 with SMTP id 26so1615214yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2009 12:49:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090701193657.GD3473@tuxdriver.com>
References: <1246388712.4949.52.camel@localhost> <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>
	<1246396179.4949.76.camel@localhost> <43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com>
	<1246464991.4331.18.camel@localhost> <4A4BA21F.1070101@gmail.com>
	<43e72e890907011112l220874bbu8db8808f666bbd4d@mail.gmail.com>
	<1246473300.30522.10.camel@localhost.localdomain> <20090701193657.GD3473@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 1 Jul 2009 12:49:33 -0700
Message-ID: <43e72e890907011249j95103a2t1b6b60ad7a1da9d3@mail.gmail.com>
Subject: Re: Insist on cfg80211 for new drivers?
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, Dave <kilroyd@googlemail.com>,
	Karl Relton <karllinuxtest.relton@ntlworld.com>,
	dwmw2@infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 1, 2009 at 12:36 PM, John W. Linville<linville@tuxdriver.com> wrote:
> On Wed, Jul 01, 2009 at 02:35:00PM -0400, Dan Williams wrote:
>
>> That's really all I
>> care about, I don't want another WEXT-based driver accepted; I want all
>> the new ones using cfg80211.
>
> Now there is a discussion we should have had in Berlin...is it time
> to insist on cfg80211-based configuration for all new drivers?

Otherwise they get sent to staging? :)

  Luis
