Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60159 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbXGJQmG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 12:42:06 -0400
Message-ID: <4693B6D6.7070305@garzik.org>
Date: Tue, 10 Jul 2007 12:41:58 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] eeprom_93cx6: shorten pulse timing to match spec (bis)
References: <20070702210345.GA22610@electric-eye.fr.zoreil.com> <20070703123441.GA3534@tuxdriver.com> <20070703223144.GA13714@electric-eye.fr.zoreil.com>
In-Reply-To: <20070703223144.GA13714@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Francois Romieu wrote:
> Based on an original idea by John W. Linville.
> 
> It is the missing part of 42d45ccd60636c28e35c2016f091783bc14ad99c
> 
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
> ---
>  drivers/misc/eeprom_93cx6.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

applied


