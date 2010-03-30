Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:9321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab0C3Stf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 14:49:35 -0400
Received: by fg-out-1718.google.com with SMTP id 19so206176fgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 11:49:34 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: CRDA and ath5k with no country code in EEPROM
Date: Tue, 30 Mar 2010 20:49:23 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <m3tys0tbhk.fsf@intrepid.localdomain> <43e72e891003300928qdd70de4vc7585d7e19d36dca@mail.gmail.com> <m3wrwtoekv.fsf@intrepid.localdomain>
In-Reply-To: <m3wrwtoekv.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003302049.24231.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 30 March 2010 20:21:36 Krzysztof Halasa wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com> writes:
> 
> > My point was that this is not something meant to be interpreted by
> > anyone for what "default country" means, the documentation I pointed
> > out clearly states that 0x0 is designed to mean to match the "US" by
> > Atheros hardware as per hardware documentation provided to ODMs.
> 
> I understand this, but the reality is that I have to work with hardware
> and software, not with the docs provided by Atheros to some other
> parties.
> 
> Software (the official Atheros driver, to be precise) says 0 isn't
> exactly US.
> Hardware (card) manufacturer says 0 isn't US.

Are you sure, you (or the hw manufacturer for that matter) didn't confuse
the country code with regdomain code?

because while they have more or less the same function, they do have different
mappings. The 0x00 country code is reserved for the FCC (US), while the 0x00
regdomain code is a described as "debug" with supposedly no limitations?!

Regards,
	Chr
