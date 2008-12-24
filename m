Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:34871 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYLXVEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 16:04:50 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: p54: ad-hoc mode doesn't work
Date: Wed, 24 Dec 2008 22:03:22 +0100
Cc: "Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <200812230132.21839.rossi.f@inwind.it> <200812241828.49679.rossi.f@inwind.it> <43e72e890812240940oa599bdds7db3682bfbf95a49@mail.gmail.com>
In-Reply-To: <43e72e890812240940oa599bdds7db3682bfbf95a49@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200812242203.22987.rossi.f@inwind.it> (sfid-20081224_220457_555311_C5E9675E)
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 24 December 2008, Luis R. Rodriguez wrote:

> Most distributions are using >= 2.6.28 kernels with
> CONFIG_WIRELESS_OLD_REGULATORY which means the US is the default
> regulatory domain and its built statically into the kernel so the
> values are used CRDA does not have to be queried. If CRDA is present
> the regulatory domain is just updated with
> CONFIG_WIRELESS_OLD_REGULATORY.

Thank you for the explanation! Now I have disabled 
CONFIG_WIRELESS_OLD_REGULATORY and I have installed CRDA and iw. After 
setting the country I'm able to create the ad-hoc IBSS between the two PCs.

According to my opinion the error message posted in the original message of 
this thread might be misleading for the user: the network card doesn't enter 
in ad-hoc mode because the country for the CRDA is not set while the error 
says that the ad-hoc mode is not supported. What do you think about?

Regards,
Fabio
