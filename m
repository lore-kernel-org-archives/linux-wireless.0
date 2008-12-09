Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49096 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbYLIW1b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 17:27:31 -0500
Subject: Re: [Orinoco-devel] [PATCH 2/2] orinoco: Fix inappropriate use of
	IRQ_BAP
From: Pavel Roskin <proski@gnu.org>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
In-Reply-To: <1228859189-12867-2-git-send-email-kilroyd@googlemail.com>
References: <1228859189-12867-1-git-send-email-kilroyd@googlemail.com>
	 <1228859189-12867-2-git-send-email-kilroyd@googlemail.com>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 17:27:19 -0500
Message-Id: <1228861639.2567.3.camel@dv> (sfid-20081209_232733_988299_062699C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-12-09 at 21:46 +0000, David Kilroy wrote:
> This hardware buffer should only be used from an interrupt. The
> wireless event generation functions are called from a workqueue, so use
> USER_BAP instead.
> 
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>

Signed-off-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
