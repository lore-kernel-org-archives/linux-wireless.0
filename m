Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2061 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZDCCEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 22:04:09 -0400
Date: Thu, 2 Apr 2009 22:03:58 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Will Keaney <keaneyw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Trouble Associating with ath5k on AR5212
Message-ID: <20090403020358.GA12406@hash.localnet> (sfid-20090403_040412_992941_1E6A69D0)
References: <49D4C7B3.7010803@gmail.com> <b6c5339f0904020805w5e210c2bl542eadb20ac5d6c7@mail.gmail.com> <49D56445.20502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49D56445.20502@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 02, 2009 at 09:20:05PM -0400, Will Keaney wrote:
> For what it's worth, I have also tried using iwconfig to associate to
> the neighbor's network under ath5k without success.  So I don't think
> it's related to wpa_supplicant's scanning algorithm.

Well it's a long shot but I thought I'd mention it because I had
very similar results due to long scans, where wpa_supplicant would
time out and fail associations.  

Try 'dmesg -n 7', then capture the output of dmesg while trying to
associate, that should show the reason (CONFIG_PRINTK_TIME=y is helpful
too). 

-- 
Bob Copeland %% www.bobcopeland.com

