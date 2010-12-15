Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2697 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab0LOI7Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 03:59:16 -0500
Subject: Re: pull request:  staging: ath6kl: linux kernel style cleanups
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <Vipin.Mehta@Atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, devel@driverdev.osuosl.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1292402343.26726.155.camel@Joe-Laptop>
References: <AANLkTimfPFeLy5sfDDS5fXiK8X8UT2x8dhzZ+_FEjrTo@mail.gmail.com>
	 <1292363199.26726.34.camel@Joe-Laptop>
	 ,<AANLkTikD440S8AWcOdib7BfTR5a7CaTuYjkysi43oaQZ@mail.gmail.com>
	 <35B17FE5076C7040809188FBE7913F98406D8912FE@SC1EXMB-MBCL.global.atheros.com>
	 <1292402343.26726.155.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 00:59:14 -0800
Message-ID: <1292403554.26726.163.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-15 at 00:39 -0800, Joe Perches wrote:
> staging: ath6kl: Convert (status != A_OK) to (!status)

Hmm.

It seems I'm must be getting sleepy.

The patch is correct but the subject has the
resultant test inverted.

It should be "(status != A_OK) to (status)".

I'll fix it later if anyone wants it done.


