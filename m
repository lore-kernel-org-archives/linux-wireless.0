Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:4173 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601Ab2H3VNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 17:13:09 -0400
Message-ID: <503FD763.6020300@gmail.com> (sfid-20120830_231322_389940_10C38291)
Date: Thu, 30 Aug 2012 23:13:07 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH 04/14] rt2x00: Align rt2500pci GPIOCSR definition with
 datasheet.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/12 23:06, Jonathan Nieder wrote:
>> Rename GPIOCSR_BIT<x> to GPIOCSR_VAL<x> to represent the actual
>> meaning better.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> Sounds good.
> 
>> Cc: <stable@vger.kernel.org>
> 
> Should not be needed.
> 

This one is the same as the previous one you commented on. Technically
this patch is not needed in stable, but the next patch in the series is.
Unfortunately that patch depends on this one, so therefore this one is
targeted at stable as well.

---
Gertjan
