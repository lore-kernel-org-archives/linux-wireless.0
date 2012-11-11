Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52075 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab2KKUlf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 15:41:35 -0500
Message-ID: <50A00D65.7000204@hauke-m.de> (sfid-20121111_214145_056785_AB45A722)
Date: Sun, 11 Nov 2012 21:41:09 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Piotr Haber <phaber@broadcom.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, m@bues.ch
Subject: Re: [PATCH] ssb: fix SPROM offset
References: <1352364447-25226-1-git-send-email-phaber@broadcom.com> <CACna6ry+nfmmBdk2EMiieGTvrn3U4kpkkDL3yMiZ7MYvpd6nCg@mail.gmail.com>
In-Reply-To: <CACna6ry+nfmmBdk2EMiieGTvrn3U4kpkkDL3yMiZ7MYvpd6nCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2012 06:53 PM, Rafał Miłecki wrote:
> 2012/11/8 Piotr Haber <phaber@broadcom.com>:
>> Offset for temperature compensation
>> values is wrong in ssb SPROMv8 map.
> 
> Thanks, you can also take a look at "Wrong offset for
> SSB_SPROM4_ANTAVAIL?" thread:
> http://lists.infradead.org/pipermail/b43-dev/2011-April/001041.html
> Not sure if that mistakes were fixed.
> 
Hi

yes SSB_SPROM4_ANTAVAIL is wrong, I updated the wiki page [0] for sprom
to match the table from the driver/SoC SDK version 6.30.39.31. The table
is mostly automatically generated from the structures broadcom uses in
their driver, this is from the ISC licensed part.

Hauke

[0]: http://bcm-v4.sipsolutions.net/SPROM
