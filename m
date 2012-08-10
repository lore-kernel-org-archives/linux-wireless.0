Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2588 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757944Ab2HJJCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 05:02:45 -0400
Message-ID: <5024CE29.5030500@broadcom.com> (sfid-20120810_110250_380282_D11203BB)
Date: Fri, 10 Aug 2012 11:02:33 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH wireless?] bcma: keep info about parallel flash
 presentence
References: <1344544690-11280-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1344544690-11280-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2012 10:38 PM, Rafał Miłecki wrote:
> This allows drivers to access flash conditionally and stop crashing some
> devices.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
> John: I suggest taking it for wirelesss, AKA fix

Maybe you could mentioned devices and/or drivers crashes without this patch?

Gr. AvS

