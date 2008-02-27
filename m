Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:64122 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYB0Fyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 00:54:51 -0500
Received: by an-out-0708.google.com with SMTP id d31so578262and.103
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2008 21:54:46 -0800 (PST)
Message-ID: <40f31dec0802262154k4e768257hb8ad255e2eb1f6a2@mail.gmail.com> (sfid-20080227_055504_643357_0DE09F81)
Date: Wed, 27 Feb 2008 07:54:45 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Cc: "Bob Copeland" <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	bruno@thinktube.com, jirislaby@gmail.com
In-Reply-To: <43e72e890802261923g528f4006ofd665edbba335d99@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224042851.GE4426@makis.domain.invalid>
	 <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com>
	 <20080224175933.GA4360@hash.localnet>
	 <40f31dec0802241058h5b37a471s5092dd370a4f2a48@mail.gmail.com>
	 <43e72e890802261923g528f4006ofd665edbba335d99@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/27, Luis R. Rodriguez <mcgrof@gmail.com>:
> On Sun, Feb 24, 2008 at 1:58 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>  > 2008/2/24, Bob Copeland <me@bobcopeland.com>:
>  >
>  >
>  > > On Sun, Feb 24, 2008 at 06:45:33AM +0200, Nick Kossifidis wrote:
>  >  >  > >  +       /* Identify PCI-E cards */
>  >  >  > >  +       if((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
>  >  >  > >  +       srev >= AR5K_SREV_VER_AR5416) {
>  >  >  > >  +               ah->ah_pcie = true;
>
>
> struct pci_dev now has member,  "is_pcie" which could be used here I
>  think instead. No need to add to ath5k_hw the ah_pcie then.
>
>
>   Luis
>

What if there is a pci-e card in the future that needs _PCI bit ? I
guess for now we can work on with srevs to be safe but it's good to
know of that feature, thanx ;-)


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
