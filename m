Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:44002 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751215AbYBDU4P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 15:56:15 -0500
Date: Mon, 4 Feb 2008 21:06:14 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Thomas Ilnseher <illth@gmx.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: b43 doesn't reset hardware when loaded/unloaded [severity:
 minor]
Message-ID: <20080204210614.760595db@morte> (sfid-20080204_205621_030335_23A09EF9)
In-Reply-To: <1202153575.8270.7.camel@note.localnet>
References: <1202153575.8270.7.camel@note.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 04 Feb 2008 20:32:55 +0100
Thomas Ilnseher <illth@gmx.de> wrote:

> Hi!
> 
> I upgraded my kernel to 2.6.24, and
> so I also upgraded from bcm43xx to b43.
> 
> There used to be a problem with bcm43xx that after 
> resuming from Supend-To-Ram, wireless didn't work anymore.

[...]
 
> It doesn't work with b43. (of course replacing bcm43xx with b43).
> I *assume* that the core isn't completely reseted on insmod'ing.

This should be fixed in 2.6.24.1. A patch is available in the wireless-2.6
tree.


-- 
Ciao
Stefano
