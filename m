Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3162 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395Ab0BPAsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 19:48:10 -0500
Date: Mon, 15 Feb 2010 19:47:17 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: jirislaby@gmail.com, mickflemm@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Fix TX/RX padding for all frames
Message-ID: <20100216004717.GA6844@hash.localnet>
References: <1266190577-2423-1-git-send-email-benoit.papillault@free.fr> <b6c5339f1002151215y4c7d2f33yfd32916e0500b55c@mail.gmail.com> <4B79C565.1050701@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B79C565.1050701@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 15, 2010 at 11:06:29PM +0100, Benoit PAPILLAULT wrote:
>> Can you tell what the functional difference is between the old code and new
>> code?  E.g. a padding that would be incorrectly computed from before?
>>
>>   
> Correct. On some frames padding is incorrect. This patch is more for  
> completeness since incorrect padding is only found by sending every kind  
> of frames using a monitor interface. Moreover, since monitor interface  
> are sometimes used to debug other issues, it's better not to have bugs 
> here.

I meant, can you give an example of such a frame?

-- 
Bob Copeland %% www.bobcopeland.com

