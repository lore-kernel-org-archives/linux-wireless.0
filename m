Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:39406 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZCYHrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 03:47:51 -0400
Received: by rv-out-0506.google.com with SMTP id f9so2719427rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 00:47:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e13a36b30903250039h55c8a01cg9dada9256bc8b1ae@mail.gmail.com>
References: <43e72e890903250009hbe7bcfal546dddf731820b8e@mail.gmail.com>
	<e13a36b30903250039h55c8a01cg9dada9256bc8b1ae@mail.gmail.com>
Date: Wed, 25 Mar 2009 00:47:34 -0700
Message-ID: <43e72e890903250047o6a4ed5cfm4ebb849013e9d571@mail.gmail.com> (sfid-20090325_084752_646682_D6AE84BD)
Subject: Re: [renamed] Debian crda?
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Paul Wise <pabs@debian.org>
Cc: Debian Devel <debian-devel@lists.debian.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 25, 2009 at 12:39 AM, Paul Wise <pabs@debian.org> wrote:
> On Wed, Mar 25, 2009 at 4:09 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>
>> Last time I poked them it seemed it was not easy to figure out how to
>> deal with, if at all, the optional but recommended RSA signature stuff
>> [1] with the DFSG.
>>
>> [1] http://wireless.kernel.org/en/developers/Regulatory#RSADigitalSignature
>
> What is the percieved DFSG/RSA conflict? I can't detect any based on
> that section of the page.

Thanks Paul, then its just a matter of packaging. There is an
debian-example/ directory with a cdbs example of how to package for
wireless-regdb and crda if anyone is up for it.

  Luis
