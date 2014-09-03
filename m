Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:64211 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbaICNLC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:11:02 -0400
Received: by mail-ig0-f182.google.com with SMTP id a13so9034286igq.15
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 06:11:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQm+x0kD9m3vVv98MwYOXjfgO1noXOnzdbk5o41S+DLewQ@mail.gmail.com>
References: <CAOHJ0jTHtVvJ43y7m-=UqHeMJfNiMYU2Peg9buxXU+wBigwu5g@mail.gmail.com>
 <CA+BoTQm+x0kD9m3vVv98MwYOXjfgO1noXOnzdbk5o41S+DLewQ@mail.gmail.com>
From: Robb <rbarr138@gmail.com>
Date: Wed, 3 Sep 2014 08:10:40 -0500
Message-ID: <CAOHJ0jSoSd97vFEMgxC3cC8AnaEGdwbUiBBoeM7UfLJcha0Ujg@mail.gmail.com> (sfid-20140903_151106_383566_9E82D255)
Subject: Re: Cannot get ACS to work with hostapd-2.2 "Unknown event 49"
To: linux-wireless <linux-wireless@vger.kernel.org>,
	michal.kazior@tieto.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The problem is ath9k_htc driver doesn't support dumping survey data.
> It doesn't implement .get_survey which implies current ACS
> implementation in hostapd will not work.

I see, driver support != chipset support.  According to
http://wireless.kernel.org/en/users/Documentation/acs#Hostapd_setup
the driver does support it, but it is correct that it does not say all
chipsets supported by that driver support ACS.

If the 9271 doesn't support it then I guess it can only be the
AR7010+AR9280 or AR7010+AR9287 right? Any way to know which works?

Thanks.
