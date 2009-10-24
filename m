Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3760 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZJXQKM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 12:10:12 -0400
Date: Sat, 24 Oct 2009 12:09:38 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, linux-net@vger.kernel.org,
	linux-mips@vger.kernel.org
Subject: Re: ath5k AP kernel panic when client uses SCP
Message-ID: <20091024160938.GC31897@hash.localnet>
References: <4AD21AB4.6010208@wpkg.org> <4AE1AC69.7010904@wpkg.org> <69e28c910910230621j2176813dpe7f77b7dff5b1b44@mail.gmail.com> <4AE1AE74.4020600@wpkg.org> <4AE2EC3E.3000503@wpkg.org> <20091024125217.GA31897@hash.localnet> <4AE31CFC.1080803@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4AE31CFC.1080803@wpkg.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 24, 2009 at 05:27:56PM +0200, Tomasz Chmielewski wrote:
> Hmm, I get:
>
> 00000000 <skb_gso_segment>
>
> So I better leave the files here:
>
> http://www1.wpkg.org/skb_gso_segment/

So, do you only get this WARN() once before things go downhill?

> [  516.440000] b44: caps=(0x0, 0x0) len=52 data_len=0 ip_summed=1

The actual error is on skb_release_data, this might give a clue if
there's some corruption going on.

-- 
Bob Copeland %% www.bobcopeland.com

