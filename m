Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:3105 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbYB0F5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 00:57:22 -0500
Received: by an-out-0708.google.com with SMTP id d31so578467and.103
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2008 21:57:21 -0800 (PST)
Message-ID: <40f31dec0802262157u42fc1b3eh2e0fb91aa2e67714@mail.gmail.com> (sfid-20080227_055724_395075_D2E400E3)
Date: Wed, 27 Feb 2008 07:57:21 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 3/8] ath5k: Identify RF2413 and deal with PHY_SPENDING
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com
In-Reply-To: <43e72e890802262002m5274e417lbbd23f64980aa8d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224041908.GB4426@makis.domain.invalid>
	 <43e72e890802262002m5274e417lbbd23f64980aa8d2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/27, Luis R. Rodriguez <mcgrof@gmail.com>:
> On Sat, Feb 23, 2008 at 11:19 PM, Nick Kossifidis <mick@madwifi.org> wrote:
>  >  * Attach RF2413.
>  >
>  >   * Propertly handle different AR5K_PHY_SPENDING settings for each RF
>  >  chip by adding a field in ath5k_hw. This way we won't have to check
>  >  inside hw_reset (see next patch).
>  >
>  >  Changes-licensed-under: ISC
>  >  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
>
> Please run through checkpatch first. BTW do we know what this
>  AR5K_PHY_SPENDING is for?
>
>

Some kind of interval used to switch to 32Khz mode (power save using
external 32Khz crystal instead of core clock) i guess...


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
