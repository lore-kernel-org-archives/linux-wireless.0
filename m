Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4246 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab2GIIxV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 04:53:21 -0400
Message-ID: <4FFA9BFB.3020600@broadcom.com> (sfid-20120709_105325_158882_B4259540)
Date: Mon, 9 Jul 2012 10:53:15 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "Eloy Anguiano" <eloy.anguiano@uam.es>,
	b43-dev@lists.infradead.org,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43 does not work on broadcom 43227
References: <1341782825.4900.11.camel@zeus>
 <4FFA0A3C.3040204@lwfinger.net>
In-Reply-To: <4FFA0A3C.3040204@lwfinger.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2012 12:31 AM, Larry Finger wrote:
> I think that Broadcom will be changing brcmsmac to support these
> devices, but my understanding is that they are concentrating on fullmac
> devices at the moment.
> 
> Larry

That is correct. The bcm43227 is very similar to the bcm43228, the
difference being the supported bands. I have not heard back since I
forwarded your questions on 43228 support in brcmsmac. So for now I can
only say that bcm43227 and bcm43228 will be added in one patch.

Gr. AvS

