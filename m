Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:48727 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756325Ab1LOSqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 13:46:01 -0500
Received: by lahj13 with SMTP id j13so1946883lah.39
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 10:45:58 -0800 (PST)
Subject: Re: iw: how to see MAC address
From: Luciano Coelho <coelho@ti.com>
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMXE1-pXZm-1HreNjFyUz1geHWZbDM_dd90XAO3chMukh_j4QA@mail.gmail.com>
References: <CAMXE1-pXZm-1HreNjFyUz1geHWZbDM_dd90XAO3chMukh_j4QA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 20:45:54 +0200
Message-ID: <1323974754.2800.199.camel@cumari> (sfid-20111215_194605_837462_8E61E9B0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-15 at 16:32 +0200, Andrei Emeltchenko wrote: 
> Hi all,

Hi Andrei!


> Sorry for stupid question but how to see my MAC address with iw?
> 
> iw phy and dev show lots of information but not MAC. (I can use of
> course ifconfig)

Why not use ifconfig? If we would do it in iw, we would duplicate the
functionality.  You need to use ifconfig anyway, at least to bring the
interface up.

-- 
Cheers,
Luca.

