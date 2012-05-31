Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2521 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab2EaM1c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 08:27:32 -0400
Message-ID: <4FC76389.70600@broadcom.com> (sfid-20120531_142807_732500_62B1356A)
Date: Thu, 31 May 2012 14:26:49 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Erwin Van de Velde" <erwin.vandevelde@gmail.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Florian Fainelli" <florian@openwrt.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Dan Williams" <dcbw@redhat.com>
Subject: Re: Master mode support in iwlagn?
References: <5252852.vpKViOerhF@sylvesterjr.cmi.ua.ac.be>
 <5625918.SuzapvkoUg@sylvesterjr.cmi.ua.ac.be>
 <4FC75DA4.2090909@broadcom.com>
 <1999855.FUDAX7EfOH@sylvesterjr.cmi.ua.ac.be>
In-Reply-To: <1999855.FUDAX7EfOH@sylvesterjr.cmi.ua.ac.be>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2012 02:16 PM, Erwin Van de Velde wrote:
> I have one ethernet connection and want to share that connection over 
> wireless, preferably in AP mode although I guess ad hoc mode is possible too. 
> Just not sure if NetworkManager supports that.

NetworkManager does support ad-hoc, but your hardware need to support
beacon transmission for that as well. You could consider buying an AP.
They are not that expensive ;-)

Gr. AvS

