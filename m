Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:60288 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab3LIEZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Dec 2013 23:25:33 -0500
Date: Mon, 9 Dec 2013 15:18:21 +1100
From: James Cameron <quozl@laptop.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: Re: status of libertas_tf + sdio?
Message-ID: <20131209041821.GC14878@us.netrek.org> (sfid-20131209_052551_162817_B8F60952)
References: <20131203202607.0b445195@kemnade.info>
 <1386167786.19448.4.camel@dcbw.foobar.com>
 <CA+E=qVdY4M=bnX=pqMiMirhQ_BRg6Uc6K9Xkzvf328BaByUF1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+E=qVdY4M=bnX=pqMiMirhQ_BRg6Uc6K9Xkzvf328BaByUF1g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 06, 2013 at 01:40:00PM +0300, Vasily Khoruzhick wrote:
> Out of curiosity,
> 
> Does anyone know if it's possible to get thin firmware for 8686 with
> SPI interface?

What happens when you try?

How are you downloading firmware over SPI?

I'm not aware of a second stage firmware download helper specific to
the SPI mode.

I think it is not possible without firmware engineering.

-- 
James Cameron
http://quozl.linux.org.au/
