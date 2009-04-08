Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3689 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933855AbZDHMKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 08:10:50 -0400
Date: Wed, 8 Apr 2009 08:10:25 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Will Keaney <keaneyw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Trouble Associating with ath5k on AR5212
Message-ID: <20090408121025.GC28096@hash.localnet> (sfid-20090408_141103_980159_E5DBD154)
References: <49D4C7B3.7010803@gmail.com> <b6c5339f0904020805w5e210c2bl542eadb20ac5d6c7@mail.gmail.com> <49D56445.20502@gmail.com> <20090403020358.GA12406@hash.localnet> <49D571BB.7060406@gmail.com> <20090403122332.GA14853@hash.localnet> <49D6117D.9020408@gmail.com> <49DAB445.7040206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49DAB445.7040206@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 06, 2009 at 10:02:45PM -0400, Will Keaney wrote:
> As before, I didn't see any additional dmesg output from athk, even with
> 'dmesg -n7'.

Hmm, you should be seeing association requests in any case.  How are
you starting the wireless network?  Can you try setting the -dd option
to wpa_supplicant?

-- 
Bob Copeland %% www.bobcopeland.com

