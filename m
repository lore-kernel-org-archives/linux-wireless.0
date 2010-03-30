Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:48422 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab0C3Lqg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 07:46:36 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: CRDA and ath5k with no country code in EEPROM
References: <m3tys0tbhk.fsf@intrepid.localdomain>
	<43e72e891003291256t7f53dcfck5f8c8cf94128eeb3@mail.gmail.com>
	<m3y6hayhv1.fsf@intrepid.localdomain>
	<201003300842.18335.holgerschurig@gmail.com>
Date: Tue, 30 Mar 2010 13:46:34 +0200
In-Reply-To: <201003300842.18335.holgerschurig@gmail.com> (Holger Schurig's
	message of "Tue, 30 Mar 2010 08:42:18 +0200")
Message-ID: <m3mxxqqbfp.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig <holgerschurig@gmail.com> writes:

> Creating my won regdomain bin with my own signature was way too much for me.

I can do that but I don't think it solves the problem. Overriding the
"default" country in EEPROM or in the driver, sure it does.

I can't simply change the freq ranges assigned to US to those valid in
EU and pretend it's "fixed".
-- 
Krzysztof Halasa
