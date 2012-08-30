Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4182 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865Ab2H3VIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 17:08:06 -0400
Message-ID: <503FD633.8070307@gmail.com> (sfid-20120830_230810_870716_EDF66364)
Date: Thu, 30 Aug 2012 23:08:03 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 02/14] rt2x00: Align rt2400pci GPIOCSR definition with
 datasheet.
References: <1346355248-5331-1-git-send-email-gwingerde@gmail.com> <1346355248-5331-2-git-send-email-gwingerde@gmail.com> <1346355248-5331-3-git-send-email-gwingerde@gmail.com> <20120830210522.GA158@mannheim-rule.att.net>
In-Reply-To: <20120830210522.GA158@mannheim-rule.att.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/12 23:05, Jonathan Nieder wrote:
> Hi,
> 
> Gertjan van Wingerde wrote:
> 
>> Datasheet indicates additional fields to set the GPIO direction.
>> At the same time rename GPIOCSR_BIT<x> to GPIOCSR_VAL<x> to represent the
>> actual meaning better.
> 
> Micronit: could the latter be split into a separate patch from the
> former, to make life easier e.g. when bisecting?
> 
> Only the first part would be needed for stable@.
> 

I guess it could be split up, but I don't see the point. Technically
this patch is not needed in stable, but the next patch in the series
depends on this one and that one is targeted at stable, so therefore
this one is targeted at stable as well.

---
Gertjan
