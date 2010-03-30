Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab0C3WHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 18:07:34 -0400
Received: by pwi5 with SMTP id 5so8208887pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 15:07:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m3mxxpo8h6.fsf@intrepid.localdomain>
References: <m3tys0tbhk.fsf@intrepid.localdomain> <43e72e891003300928qdd70de4vc7585d7e19d36dca@mail.gmail.com>
	<m3wrwtoekv.fsf@intrepid.localdomain> <201003302049.24231.chunkeey@googlemail.com>
	<m3mxxpo8h6.fsf@intrepid.localdomain>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 30 Mar 2010 15:07:14 -0700
Message-ID: <n2r43e72e891003301507wb3359afcvd2e3656bc70e431c@mail.gmail.com>
Subject: Re: CRDA and ath5k with no country code in EEPROM
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 30, 2010 at 1:33 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Then again: does the regdomain = 0 means "US" or "default country" (or
> something completely different), according to Atheros' docs?

As per Atheros documentation 0x0 means "US". I've already provided
links for you. I'm sending this from an Atheros e-mail address, not
sure if this helps get this through to you or not.

 Luis
