Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:3504 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbZCYU2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 16:28:04 -0400
Received: by yw-out-2324.google.com with SMTP id 5so205849ywb.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 13:28:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890903251325k7b435c18v988f9206eb784831@mail.gmail.com>
References: <43e72e890903250009hbe7bcfal546dddf731820b8e@mail.gmail.com>
	<200903260337.37783.kel@otaku42.de> <43e72e890903251041r657a5217q9af7b5eb34f2f824@mail.gmail.com>
	<200903260442.36251.kel@otaku42.de> <e13a36b30903251203v7c53fb20g64bf61e4e433377@mail.gmail.com>
	<43e72e890903251325k7b435c18v988f9206eb784831@mail.gmail.com>
Date: Wed, 25 Mar 2009 13:27:46 -0700
Message-ID: <43e72e890903251327w18e4b8a1nd7bd125b4c6329a5@mail.gmail.com> (sfid-20090325_212820_038179_079869E8)
Subject: Re: [renamed] Debian crda?
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: debian-devel@lists.debian.org
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 25, 2009 at 1:25 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

> Actually technically it could be a different person. I maintain crda
> upstream and John maintains wireless-regdb upstream, for example. I
> just need John's pubkey file which is non-binary. CRDA just reads the
> regulatory.bin which wireless-regdb provides.

Let me be a little bit more clear on this last sentence. By provides I
mean that John generated his pubkey using it and then e-mailed it to
me. I then just merged it as part of CRDA so that by default CRDA
trusts the regulatory.bin files he puts out.

  Luis
