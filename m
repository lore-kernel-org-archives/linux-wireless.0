Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52013 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1AZQRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 11:17:07 -0500
Received: by qyj19 with SMTP id 19so5902725qyj.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 08:17:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101251947.03685.br1@einfach.org>
References: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
	<201101251423.32008.br1@einfach.org>
	<20110125103803.GA2239@hash.localnet>
	<201101251947.03685.br1@einfach.org>
Date: Wed, 26 Jan 2011 11:17:05 -0500
Message-ID: <AANLkTi=+k8EiTsP=cjBcJw943TZfn+oK1o9oEch_r_He@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath5k: correct endianness of frame duration
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, jirislaby@gmail.com, lrodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 25, 2011 at 5:47 AM, Bruno Randolf <br1@einfach.org> wrote:
> Allright, just the EIFS is affected - shouldn't be a big deal. Anyhow it's
> correct now and was wrong before.
>
> But you meant on a very busy channel, right?
>
> I'm on a BE board ;) I can try to see what difference it makes tomorrow.

Err, yeah, braino.  Glad to know BE actually works :)

-- 
Bob Copeland %% www.bobcopeland.com
