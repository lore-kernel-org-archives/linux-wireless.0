Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46319 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab1F1UAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 16:00:54 -0400
Received: by vxb39 with SMTP id 39so411406vxb.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 13:00:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=oxo6ryCaJZiF9NZSV7hA1DJqqSw@mail.gmail.com>
References: <BANLkTi=oxo6ryCaJZiF9NZSV7hA1DJqqSw@mail.gmail.com>
Date: Tue, 28 Jun 2011 15:00:53 -0500
Message-ID: <BANLkTinffSwp3mQsLZpNk5VxGnjk6jsR_Q@mail.gmail.com> (sfid-20110628_220057_315337_073B2CB0)
Subject: Re: STA Driver/MLME handling for broadcast DEAUTHENTICATE from AP
From: alfred steele <alfred.jaquez@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a quick question. How should be a broadcast deauthenticate from
an AP handled by a client driver and or MLME.
Is it the same way as a unicast deauth is ahandled.
We have a case here where the AP sends a broadcast DEAUTH to the
client, but l;ooks like the driver does not report it to the WPA
supplicant event interface in the form of a DISCONNECT or a 4 -way
handhake fail etc.?
Is it supplicant problem or a driver/firmware issue or  an AP should
not be sending Bcast Death anyway?
In summary,  need to understand if the Bcast Deauth is trated
specially or not or does it boil down to a regular EV_DISAASOC to the
wpa supplicant?
