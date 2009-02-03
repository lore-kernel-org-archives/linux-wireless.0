Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:58078 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZBCOpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 09:45:50 -0500
Received: by an-out-0708.google.com with SMTP id c2so788186anc.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 06:45:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1233670130.16539.5.camel@maxim-laptop>
References: <20090131022310.GA3342@makis>
	 <1233670130.16539.5.camel@maxim-laptop>
Date: Tue, 3 Feb 2009 09:45:48 -0500
Message-ID: <b6c5339f0902030645p541d231bg8cb4480f1d571b0a@mail.gmail.com> (sfid-20090203_154600_222313_B8EACD3B)
Subject: Re: [ath5k-devel] [PATCH 1/5] ath5k: PHY code cleanup
From: Bob Copeland <bcopeland@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 3, 2009 at 9:08 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> I just tried your 5 patches, as they could fix hangs in the device,
> that I experience occasionally, when resuming my aspire one from ram.
>
> I applied the patches, and I got very unstable system, that tended to
> hang even before X.
>
> When it didn't hang, I tried suspend to ram cycle, but it hanged then.

Pretty much a known issue for some chips, I'm trying to bisect the
changes right now (almost done).

-- 
Bob Copeland %% www.bobcopeland.com
