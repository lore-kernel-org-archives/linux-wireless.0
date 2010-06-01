Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58492 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab0FARGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 13:06:24 -0400
Received: by gye5 with SMTP id 5so1323184gye.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 10:06:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C02E1CA.10757.239262@jafojtik.seznam.cz>
References: <4C02E1CA.10757.239262@jafojtik.seznam.cz>
Date: Tue, 1 Jun 2010 13:06:23 -0400
Message-ID: <AANLkTimRxjfvS_6cR7ZN3yim3TO9GcPwJ59L3HZzpVmy@mail.gmail.com>
Subject: Re: Association problems - again
From: Bob Copeland <me@bobcopeland.com>
To: Jaroslav Fojtik <jafojtik@seznam.cz>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 30, 2010 at 6:08 PM, Jaroslav Fojtik <jafojtik@seznam.cz> wrote:
> Dears,
>
> I have found that ATH5k has severe problems during association to AP.
>
> Sometimes it needs more than 100 attempts to association, before it connects
> to AP.

Did it work in previous kernels?

You said you reverted 6b5d117eddc09cd976ad8030d715f4 and still have the
problem, right?  Are you sure you booted the kernel with the revert?

> [  149.926717] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
> [  150.013353] eth3: no IPv6 routers present
> [  150.126699] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
> [  150.326707] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
> [  150.526696] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out

Probably traffic is not being sent or received from one side.

-- 
Bob Copeland %% www.bobcopeland.com
