Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57792 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0EISy6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 14:54:58 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OBBeP-00015m-3c
	for linux-wireless@vger.kernel.org; Sun, 09 May 2010 20:54:53 +0200
Received: from 94-192-45-120.zone6.bethere.co.uk ([94.192.45.120])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 09 May 2010 20:54:53 +0200
Received: from linux by 94-192-45-120.zone6.bethere.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 09 May 2010 20:54:53 +0200
To: linux-wireless@vger.kernel.org
From: Adam Baker <linux@baker-net.org.uk>
Subject: Re: [PATCH 6/9] rt2x00: Clean up generic procedures on descriptor writing.
Date: Sun, 9 May 2010 18:54:43 +0000 (UTC)
Message-ID: <loom.20100509T205352-131@post.gmane.org>
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com> <1273354826-4335-7-git-send-email-gwingerde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan van Wingerde <gwingerde@...> writes:

> -	 *	3) Rule 2 can be broken when the available entries
> +	 *	2) Rule 2 can be broken when the available entries
>  	 *	   in the queue are less then a certain threshold.
>  	 */

shouldn't this say Rule 1 can be broken now?

Adam

