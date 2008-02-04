Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:48838 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbYBDUM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 15:12:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Thomas Ilnseher <illth@gmx.de>
Subject: Re: b43 doesn't reset hardware when loaded/unloaded [severity: minor]
Date: Mon, 4 Feb 2008 21:12:05 +0100
Cc: linux-wireless@vger.kernel.org
References: <1202153575.8270.7.camel@note.localnet>
In-Reply-To: <1202153575.8270.7.camel@note.localnet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802042112.05350.mb@bu3sch.de> (sfid-20080204_201233_116332_3CE211F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 04 February 2008 20:32:55 Thomas Ilnseher wrote:
> Hi!
> 
> I upgraded my kernel to 2.6.24, and
> so I also upgraded from bcm43xx to b43.
> 
> There used to be a problem with bcm43xx that after 
> resuming from Supend-To-Ram, wireless didn't work anymore.

Fixed in wireless-2.6 and will be fixed in the upcoming 2.6.24.1.

-- 
Greetings Michael.
