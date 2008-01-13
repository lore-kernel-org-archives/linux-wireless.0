Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:46324 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751784AbYAMTXF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 14:23:05 -0500
Date: Sun, 13 Jan 2008 20:16:53 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: remove unused variable
Message-ID: <20080113201653.2c36391e@morte> (sfid-20080113_192310_018194_84821BE6)
In-Reply-To: <200801132014.53522.IvDoorn@gmail.com>
References: <20080113194834.677af663@morte>
	<200801132014.53522.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 13 Jan 2008 20:14:53 +0100
Ivo van Doorn <ivdoorn@gmail.com> wrote:

> Hi,
> 
> > Remove an unused variable that caused a warning while building. Please note
> > that the pipe obtained there isn't used anywhere else.
> 
> This patch is in wireless-2.6 already...

Actually, I thought I already sent this patch, but couldn't find it
anywhere, neither in my outbox nor in git-log. Could you tell me what's the
related SHA commit? Thanks.


-- 
Ciao
Stefano
