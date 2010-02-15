Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f224.google.com ([209.85.217.224]:44145 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab0BOUPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 15:15:16 -0500
Received: by gxk24 with SMTP id 24so5167770gxk.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Feb 2010 12:15:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266190577-2423-1-git-send-email-benoit.papillault@free.fr>
References: <1266190577-2423-1-git-send-email-benoit.papillault@free.fr>
Date: Mon, 15 Feb 2010 15:15:16 -0500
Message-ID: <b6c5339f1002151215y4c7d2f33yfd32916e0500b55c@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Fix TX/RX padding for all frames
From: Bob Copeland <me@bobcopeland.com>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: jirislaby@gmail.com, mickflemm@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 14, 2010 at 6:36 PM, Benoit Papillault
<benoit.papillault@free.fr> wrote:
> Instead of computing the padding size based on the IEEE 802.11 header length,
> we directly compute the padding position first and then the padding size next.
> We have changed some functions to pass them the padding size directly. It has
> been tested using a monitor interface in TX and RX against a different chipset
> (zd1211rw to name it)

Can you tell what the functional difference is between the old code and new
code?  E.g. a padding that would be incorrectly computed from before?

-- 
Bob Copeland %% www.bobcopeland.com
