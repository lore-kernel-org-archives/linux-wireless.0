Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54345 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab0KVVTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 16:19:38 -0500
Received: by gyb11 with SMTP id 11so1670413gyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 13:19:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinu+xPRZyWT0_rzDXi3Z6p6BoTpLVTLdK=5yKee@mail.gmail.com>
References: <AANLkTinu+xPRZyWT0_rzDXi3Z6p6BoTpLVTLdK=5yKee@mail.gmail.com>
Date: Mon, 22 Nov 2010 16:19:35 -0500
Message-ID: <AANLkTinBH4gEaF-MEGab_nDmFzJQYa_=bTnai264SB5q@mail.gmail.com>
Subject: Re: Issue with ath9k driver
From: Bob Copeland <me@bobcopeland.com>
To: Martin Dubuc <martind1111@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 22, 2010 at 10:56 AM, Martin Dubuc <martind1111@gmail.com> wrote:
> I have found an issue with the ath9k driver that first appeared in
> Fedora 13 kernel and also found in latest Fedora 14 kernel
> (2.6.35.6-48). I do not know if this issue was already raised and a
> fix has already been identified.
[...]
> The ath5k driver had similar issue in Fedora 13, but the problem was
> solved in Fedora 14 kernel.

In the ath5k case it was most likely a stray ieee80211_stop_queues()
without the corresponding restart.

But since I have no idea what F-13 vs F-14 kernels are, that's just a
guess.

-- 
Bob Copeland %% www.bobcopeland.com
