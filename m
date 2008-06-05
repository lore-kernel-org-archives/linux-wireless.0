Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:11237 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbYFEKoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 06:44:04 -0400
Received: by wa-out-1112.google.com with SMTP id j37so367310waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2008 03:44:04 -0700 (PDT)
Message-ID: <1ba2fa240806050343t51b9c63t369e871d38dc0bcd@mail.gmail.com> (sfid-20080605_124411_155189_0D48C5BA)
Date: Thu, 5 Jun 2008 13:43:58 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>
Subject: Re: Page allocation failure in 2.6.26-rc2 (iwl4965 driver)
Cc: "maximilian attems" <max@stro.at>, linux-wireless@vger.kernel.org
In-Reply-To: <20080605094343.GG5012@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080604130307.GN5012@ics.muni.cz>
	 <20080604130452.GD9258@baikonur.stro.at>
	 <20080604185743.GQ5012@ics.muni.cz>
	 <1ba2fa240806041209i5e3fbb35r5667314ea9417379@mail.gmail.com>
	 <1ba2fa240806050154w6bee2f08n80031e09ac12e9ed@mail.gmail.com>
	 <20080605094343.GG5012@ics.muni.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/6/5 Lukas Hejtmanek <xhejtman@ics.muni.cz>:
> On Thu, Jun 05, 2008 at 11:54:36AM +0300, Tomas Winkler wrote:
>> Actually I've already posted the patch that fixes allocation. It' just
>> not in rc2
>> http://marc.info/?l=linux-wireless&m=121205035427353&w=2
>
> unfortnately, it does not fix my allocation failure as that failure is caused
> by kmalloc allocation tx_queue which is struct size * TFD_QUEUE_SIZE_MAX
> large.

Okay I will post one more fix that  should restart flow.
Anyhow I think this is all caused but dma allocation changes see this thread.
http://marc.info/?l=linux-kernel&m=121240178718502&w=2
Tomas
