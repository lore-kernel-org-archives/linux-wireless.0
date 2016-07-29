Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cit-hm8-mail01.bmw-carit.de ([212.118.206.84]:38268 "EHLO
	cit-hm8-gw01.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751368AbcG2GHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2016 02:07:43 -0400
Subject: Re: [RFC v0 3/8] firmware: Factor out firmware load helpers
To: Dan Williams <dcbw@redhat.com>, Daniel Wagner <wagi@monom.org>,
	Bastien Nocera <hadess@hadess.net>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-4-git-send-email-wagi@monom.org>
 <1469718061.3013.18.camel@redhat.com>
CC: <linux-input@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Message-ID: <6361319e-ffaa-4333-6aba-4829a1953c7f@bmw-carit.de> (sfid-20160729_080746_683328_FA96A05E)
Date: Fri, 29 Jul 2016 08:07:33 +0200
MIME-Version: 1.0
In-Reply-To: <1469718061.3013.18.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It's somewhat odd to me that the structure is "firmware_stat" but most
> of the functions are "fw_loading_*".  That seems inconsistent for a
> structure that is (currently) only used by these functions.

I agree, my proposal is odd.

> I would personally do either:
>
> a) "struct fw_load_status" and "fw_load_*()"
>
> or
>
> b) "struct firmware_load_stat" and "firmware_load_*()"
>
> I'd also change the function names from "loading" -> "load", similar to
> how userland has read(2), not reading(2).

a) sounds good to me, because fw_load_ should be long enough prefix.

cheers,
daniel
