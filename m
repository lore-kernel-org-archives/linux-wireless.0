Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:18072 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbYHARpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 13:45:07 -0400
Received: by an-out-0708.google.com with SMTP id d40so183963and.103
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 10:45:06 -0700 (PDT)
Message-ID: <43e72e890808011045o57ba1aecwb14b5f3dce049a1@mail.gmail.com> (sfid-20080801_194521_595015_A97C3C3E)
Date: Fri, 1 Aug 2008 10:45:06 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: Vendor support stickers for devices supported under Linux wireless
Cc: "Michael Renzmann" <mrenzmann@madwifi.org>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1217610561.13107.28.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890807301327j54be2453r836964c708d75458@mail.gmail.com>
	 <40f31dec0807310657l36b052bfu510415d50c14718d@mail.gmail.com>
	 <3659.194.45.26.221.1217581093.squirrel@webmail.madwifi.org>
	 <1217610561.13107.28.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 1, 2008 at 10:09 AM, Pavel Roskin <proski@gnu.org> wrote:
> On Fri, 2008-08-01 at 10:58 +0200, Michael Renzmann wrote:
>
>> How about a "Linux Wireless Foundation"? Some kind of official entity that
>> wireless vendors could talk to for Linux support, certification process
>> for getting the logo, and so on.
>
> My concern is that giving any certification would imply that we promise
> to keep the driver in the Linux sources.  However, I don't think we can
> accept legal obligations on behalf of the developers.
>
> Linus can remove any driver at any time.  We can hope that he will act
> rationally, but even then, the driver may be found to have fundamental
> problems after the certification.  If Linus removes a driver for a
> certified device, will "Linux Wireless Foundation" fork the kernel?

I'm not really concerned about that, I think we're side tracking a bit
from the original intention behind this thing which is to help users
get stuff that works on Linux and is supported. For now it seems
reasonable to get the driver in Linus' tree and to have support for
it.

  Luis
