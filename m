Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:42638 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZGAV44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 17:56:56 -0400
Received: by gxk26 with SMTP id 26so1913954gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2009 14:56:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246485123.12994.168.camel@localhost.localdomain>
References: <1246388712.4949.52.camel@localhost> <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>
	<1246396179.4949.76.camel@localhost> <43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com>
	<1246464991.4331.18.camel@localhost> <4A4BA21F.1070101@gmail.com>
	<43e72e890907011112l220874bbu8db8808f666bbd4d@mail.gmail.com>
	<1246473300.30522.10.camel@localhost.localdomain> <20090701193657.GD3473@tuxdriver.com>
	<1246485123.12994.168.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 1 Jul 2009 14:56:39 -0700
Message-ID: <43e72e890907011456q7e3d9f5al1057f940a7655cda@mail.gmail.com>
Subject: Re: Insist on cfg80211 for new drivers?
To: Marcel Holtmann <marcel@holtmann.org>, Greg KH <greg@kroah.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, Dave <kilroyd@googlemail.com>,
	Karl Relton <karllinuxtest.relton@ntlworld.com>,
	dwmw2@infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 1, 2009 at 2:52 PM, Marcel Holtmann<marcel@holtmann.org> wrote:
> Hi John,
>
>> > That's really all I
>> > care about, I don't want another WEXT-based driver accepted; I want all
>> > the new ones using cfg80211.
>>
>> Now there is a discussion we should have had in Berlin...is it time
>> to insist on cfg80211-based configuration for all new drivers?
>
> there is really nothing much to discuss on this topic. The plan is to
> deprecate WEXT, that simple. So if the driver has no cfg80211 support,
> then it will not be included. Period.
>
> Send such drivers off to staging and let them have their 6 month.  Then
> we either remove them again or they got ported to cfg80211.

6 months only in staging ? Is this a rule now for staging?

  Luis
