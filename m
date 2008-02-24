Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:38985 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYBXXXg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 18:23:36 -0500
Received: by an-out-0708.google.com with SMTP id d31so314314and.103
        for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2008 15:23:35 -0800 (PST)
Message-ID: <40f31dec0802241523w247034bfs4b0f283a876f6a3@mail.gmail.com> (sfid-20080224_232358_917930_862659C0)
Date: Mon, 25 Feb 2008 01:23:35 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
In-Reply-To: <20080224202112.GA4545@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224042851.GE4426@makis.domain.invalid>
	 <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com>
	 <20080224175933.GA4360@hash.localnet>
	 <40f31dec0802241058h5b37a471s5092dd370a4f2a48@mail.gmail.com>
	 <20080224202112.GA4545@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/24, Bob Copeland <me@bobcopeland.com>:
> On Sun, Feb 24, 2008 at 08:58:09PM +0200, Nick Kossifidis wrote:
>  > Thanx, just plz put a new line here ->
>  >
>  > +     /* Get MAC, PHY and RADIO revisions */
>  > +     srev = ath5k_hw_reg_read(ah, AR5K_SREV);
>  > +
>  > +     /* Identify PCI-E cards */
>
>
> > Acked-by: Nick Kossifidis <mickflemm@gmail.com>
>
>
> Do you want me to respin and post the patch with the newline, or
>  are you just going to roll it into your changes?  I don't mind
>  either way, but if you pick it up, feel free to add my:
>
>  Tested-by: Bob Copeland <me@bobcopeland.com>
>
>

Yup, can you post a patch on top of the series ? Also remove braces
etc as Christoph said if you like (i prefer to keep the "else" there).


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
