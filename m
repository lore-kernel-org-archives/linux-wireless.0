Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:56815 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751003AbdHXB3f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 21:29:35 -0400
Date: Thu, 24 Aug 2017 11:29:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        linuxwifi@intel.com
Subject: Re: pull-request: iwlwifi-next 2017-08-18
Message-ID: <20170824112934.169e1094@canb.auug.org.au> (sfid-20170824_032938_325761_C8E63A8D)
In-Reply-To: <87pobmwbqo.fsf@kamboji.qca.qualcomm.com>
References: <1503132116.15969.327.camel@coelho.fi>
        <87pobmwbqo.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Wed, 23 Aug 2017 18:21:51 +0300 Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Luca Coelho <luca@coelho.fi> writes:
>=20
> > Here's my third pull-request intended for v4.14.=C2=A0 We continued doi=
ng
> > generic development work, with improvements, bug fixes and=C2=A0cleanup=
s all
> > around.=C2=A0 More=C2=A0details in the tag description.
> >
> > My patch "iwlwifi: update channel flags parser" is going to cause a
> > conflict with net because they both change the same string in debug
> > message.  Emmanuel's patch "iwlwifi: split the regulatory rules when the
> > bandwidth flags require it" added "reg_flags" to the string and changed
> > the Ad-hoc string.  My patch added a few %s's and also changed the Ad-
> > hoc string.  The result of the conflict resolution should look like
> > this:
> >
> > "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s%s%s%s(0x%02x) reg_flags 0x%x: %s\n" =
=20
>=20
> Thanks, I'll Cc Stephen because he most probably sees that conflict
> tomorrow.

Thanks for the heads up ...

--=20
Cheers,
Stephen Rothwell
