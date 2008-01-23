Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:33549 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750855AbYAWNF3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 08:05:29 -0500
Date: Wed, 23 Jan 2008 13:55:09 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix rfkill allocation leakage in error paths
Message-ID: <20080123135509.539f645f@morte> (sfid-20080123_130533_112660_974EF2F3)
In-Reply-To: <200801231215.38768.mb@bu3sch.de>
References: <200801231215.38768.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 23 Jan 2008 12:15:38 +0100
Michael Buesch <mb@bu3sch.de> wrote:

> We must kill rfkill in any error paths that trigger after rfkill init.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Acked-by: Stefano Brivio <stefano.brivio@polimi.it>


--
Ciao
Stefano
