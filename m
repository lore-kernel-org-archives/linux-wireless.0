Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4513 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbYAHVup (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 16:50:45 -0500
Date: Tue, 8 Jan 2008 16:29:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Marcin Juszkiewicz <openembedded@haerwu.biz>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	netdev@vger.kernel.org
Subject: Re: [PATCH] Add Linksys WCF11 to hostap driver
Message-ID: <20080108212928.GC3086@tuxdriver.com> (sfid-20080108_215049_853974_164D60DE)
References: <200712281416.59079.openembedded@haerwu.biz> <1198901689.2221.3.camel@dv> <200712301600.46342.openembedded@haerwu.biz> <20071230113931.d96ytsjusgos48oo@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071230113931.d96ytsjusgos48oo@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 30, 2007 at 11:39:31AM -0500, Pavel Roskin wrote:
> Quoting Marcin Juszkiewicz <openembedded@haerwu.biz>:
>
>> +       PCMCIA_DEVICE_PROD_ID1233(
>> +               "The Linksys Group, Inc.", "Wireless Network CF  Card", 
>> "ISL37300P",
>> +               0xa5f472c2, 0x9c05598d, 0xc9049a39),
>
> Acked-by: Pavel Roskin <proski@gnu.org>

The ID1234 version of this patch is already in Linus' tree.  Feel free
to submit a patch that redacts it to the ID123 form.

John
-- 
John W. Linville
linville@tuxdriver.com
