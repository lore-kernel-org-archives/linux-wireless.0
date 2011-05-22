Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:37019 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008Ab1EVJBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 05:01:40 -0400
Date: Sun, 22 May 2011 10:59:56 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
Message-ID: <20110522105956.3b7a9fa2@absol.kitzblitz> (sfid-20110522_110148_964239_3401E617)
In-Reply-To: <1306051680-2354-1-git-send-email-arend@broadcom.com>
References: <1306051680-2354-1-git-send-email-arend@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* "Arend van Spriel" <arend@broadcom.com>:
> +/**
> + * crc8() - calculate a crc8 over the given input data
> + *
> + * @pdata:	pointer to data buffer.
> + * @nbytes:	number of bytes in data buffer.
> + * @crc:	previous returned crc8 value.
> + *
> + * The CRC8 is calculated using the polynomial given below.
> + *
> + * x^8 + x^7 +x^6 + x^4 + x^2 + 1
                 ^
Could you possibly add a space here ...

> +/*
> + * table for crc8 calculation based on following polynomial:
> + *	x^8 + x^7 +x^6 + x^4 + x^2 + 1
                   ^
           ... and here?

Best regards,
Nicolas Kaiser
