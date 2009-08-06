Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:57292 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbZHFTYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 15:24:16 -0400
Received: by gxk9 with SMTP id 9so1409602gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 12:24:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249585684.19169.12.camel@mj>
References: <4A7A8F7E.6020503@redfish-solutions.com> <1249569993.6446.2.camel@jdl-desktop>
	<1249576886.14919.16.camel@mj> <43e72e890908060956j3548c23ak4cf98d11c32efec0@mail.gmail.com>
	<1249580707.14919.29.camel@mj> <43e72e890908061142w41d3c0e8x1dc81ffd3ac5b8ae@mail.gmail.com>
	<1249585684.19169.12.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Aug 2009 12:23:55 -0700
Message-ID: <43e72e890908061223i7efe13c0t2ad1ed2da90464d4@mail.gmail.com>
Subject: Re: CRDA and cross-compilation
To: Pavel Roskin <proski@gnu.org>
Cc: Jon Loeliger <jdl@bigfootnetworks.com>,
	"Philip A. Prindeville" <philipp_subx@redfish-solutions.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 6, 2009 at 12:08 PM, Pavel Roskin<proski@gnu.org> wrote:
> On Thu, 2009-08-06 at 11:42 -0700, Luis R. Rodriguez wrote:
>
>> > -all: $(REG_BIN) crda intersect verify
>> > +all: all_noverify verify
>> > +
>> > +all_noverify: crda intersect regdbdump
>>
>> You removed REG_BIN from here, was that intentional?
>
> Yes.  It's not needed for the build.  As for the "verify" target, it
> already depends on $(REG_BIN)

Oh nice, thanks applied!

  Luis
