Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:36466 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1CCIfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 03:35:33 -0500
Subject: Re: [PATCH] Update ar9271.fw
From: David Woodhouse <dwmw2@infradead.org>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1297057905-2518-1-git-send-email-vnatarajan@atheros.com>
References: <1297057905-2518-1-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 08:34:50 +0000
Message-ID: <1299141290.24834.57.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-07 at 05:51 +0000, Vivek Natarajan wrote:
> * Enable bluetooth coexistence.
> * Fix disconnection issue with WEP and TKIP noticed in some APs.

Would be useful if that and some kind of version information were
available in the WHENCE file or somewhere, rather than just in the git
revision history. But I've applied the patch; sorry for the delay.

-- 
dwmw2

