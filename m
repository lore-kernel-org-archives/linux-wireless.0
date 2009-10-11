Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4098 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbZJKWY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 18:24:58 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.31.[12] ath5k regression
Date: Sun, 11 Oct 2009 18:23:56 -0400
Message-Id: <20091011222142.M14763@bobcopeland.com>
In-Reply-To: <20091011220002.GA11603@linux-m68k.org>
References: <20090621134954.GA31505@linux-m68k.org> <20090621180447.GA29469@hash.localnet> <20090623174616.GA3914@linux-m68k.org> <20090623202541.GA3635@hash.localnet> <20090625083636.GA6323@linux-m68k.org> <20090705123105.GE2132@hash.localnet> <20091009143922.GA7848@linux-m68k.org> <20091010125824.GA18841@hash.localnet> <20091011122616.GA27105@linux-m68k.org> <20091011133010.GA21494@hash.localnet> <20091011220002.GA11603@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 12 Oct 2009 00:00:02 +0200, Richard Zidlicky wrote:
> so the results are same like before. The printk message came once only,
> I will try to gather more debug info tomorrow.

Meaning it works the same as with your change (replacing "chan != null"
with "true") or it works the same as mainline, i.e. it fails?

-- 
Bob Copeland %% www.bobcopeland.com


