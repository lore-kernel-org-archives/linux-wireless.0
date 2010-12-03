Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38751 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331Ab0LCESD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 23:18:03 -0500
Received: by iwn42 with SMTP id 42so1778078iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 20:18:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101203041109.GE2988@makis.mantri>
References: <20101203041109.GE2988@makis.mantri>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 2 Dec 2010 20:17:41 -0800
Message-ID: <AANLkTi=n0wkMTWxJvvNHHMyjvGA25JSr8awWKMJsAv+g@mail.gmail.com>
Subject: Re: [PATCH 5/6] ath5k: Update version string
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 2, 2010 at 8:11 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>  * Change version number, we've added various new features lately.
>  We need to find a way to maintain this, maybe on each kernel release
>  or something. Also remove "EXPERIMENTAL", we aren't experimental any
>  more I think ;-)
>
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

> +MODULE_VERSION("0.7.0");

How about just remove this all together, the version should go by the
kernel or git describe.

Luis
