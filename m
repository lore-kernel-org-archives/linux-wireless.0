Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:53813 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab3IJHuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 03:50:06 -0400
Message-ID: <1378799431.4799.63.camel@porter.coelho.fi> (sfid-20130910_095010_938028_4FFC0787)
Subject: Re: [PATCH 12/12] wlcore: always register dummy hardirq
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Sep 2013 10:50:31 +0300
In-Reply-To: <1378218848-7853-12-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	 <1378218848-7853-12-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> This keeps the kernel happy when using edge-irqs and requesting a
> threaded irq.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Ouch, I think this is not going to fit at all with the DT patches I
sent.

BTW, someone should probably take over those patches, rework according
to the reviews and submit them again, as I don't think I'll have the
time to rework them anytime soon... :(

--
Luca.

