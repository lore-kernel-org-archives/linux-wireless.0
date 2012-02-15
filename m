Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:33191 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390Ab2BOF6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 00:58:49 -0500
Received: by mail-lpp01m020-f177.google.com with SMTP id n10so484203lbo.22
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 21:58:47 -0800 (PST)
Message-ID: <1329285523.19569.16.camel@cumari> (sfid-20120215_065852_686198_0F372629)
Subject: Re: wl12xx: BUG: scheduling while atomic: kworker
From: Luciano Coelho <coelho@ti.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 15 Feb 2012 07:58:43 +0200
In-Reply-To: <20120215040307.GA4387@shredder>
References: <CAG6hwVNXru0bN+MZNf+vwN=LGFn9G8EpzK+A=FOCHwe0yYCbyQ@mail.gmail.com>
	 <20120215040307.GA4387@shredder>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-14 at 20:03 -0800, Thomas Pedersen wrote: 
> Sorry, gmail ate the formatting. Resending:

Thanks for your report.  This looks interesting, something to do with
the SDIO.

What exactly did you try to do? Was it 3.3-rc3 vanilla? Or
wireless-testing?

How are you configuring the MMC for wl12xx in your board file?


-- 
Cheers,
Luca.

