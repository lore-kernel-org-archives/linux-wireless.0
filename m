Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:44567 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbZCZV0v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 17:26:51 -0400
Received: by qw-out-2122.google.com with SMTP id 8so884667qwh.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 14:26:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49CBDE6A.6040702@lwfinger.net>
References: <49CBDE6A.6040702@lwfinger.net>
Date: Thu, 26 Mar 2009 17:26:48 -0400
Message-ID: <30353c3d0903261426u56c47af9oe15d9775db171714@mail.gmail.com> (sfid-20090326_222654_847912_7F72824A)
Subject: Re: [RFT/RFC 1/2] b43legacy: Fixes for beacons
From: David Ellingsworth <david@identd.dyndns.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2009 at 3:58 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> This patch ports the beaconing fixes from commit a82d992261f "b43: Beaconing
> fixes" to b43legacy. Basically it prevents the card from triggering the beacon
> IRQ over and over again.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> Did these 2 patches work for you?
>
> Larry
>

I haven't had a chance to test these as of yet. I had to wait a few
extra days in order for my new wireless card to come in (couldn't
really test in AP mode with only one card). I built a new kernel last
night with these patches, but I still need to setup and configure
hostapd. Hopefully, I'll know more later tonight. I'll run tests with
and without these patches.

Regards,

David Ellingsworth
