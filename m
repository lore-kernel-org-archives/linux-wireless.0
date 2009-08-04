Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33267 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbZHDWcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 18:32:24 -0400
Received: by bwz19 with SMTP id 19so3362255bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 15:32:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908050027.29829.mb@bu3sch.de>
References: <83a869cd0907271349h248204at74cc1603419fc83b@mail.gmail.com>
	 <200908050006.02754.mb@bu3sch.de>
	 <83a869cd0908041523m7b2be0c9t4ae21dc2e22c537@mail.gmail.com>
	 <200908050027.29829.mb@bu3sch.de>
Date: Wed, 5 Aug 2009 00:32:23 +0200
Message-ID: <83a869cd0908041532x54ec1116m78c617eaec41cfa9@mail.gmail.com>
Subject: Re: [RESEND] [PATCHv2] b43 add harware tkip
From: gregor kowski <gregor.kowski@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Yeah, I do understand this bug. My question was if that is the only bug.
>
Sorry, yes this is the only one.

>> So max_nr_keys seems wrong in case of new API.
>
> It's not that simple, actually.
> The max_nr_keys thing was never meant to specify which API we're on.
> It was invented to do the RCMTA vs *oldcrappymechanismiforgotthenameof*.
> max_nr_keys essentially became obsolete and dead code when b43 did not
> support <rev5 anymore. I will submit a patch which removes it and cleans up
> the code alltogether.
Ok, thanks
