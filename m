Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:42798 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752449AbYA0Tjl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 14:39:41 -0500
Date: Sun, 27 Jan 2008 20:37:35 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: [PATCH 1/2] rc80211-pid: fix adjusted index check
Message-ID: <20080127203735.3b32a1ce@morte> (sfid-20080127_193948_103472_618B129B)
In-Reply-To: <20080126040217.7c5d2928@morte>
References: <20080126040217.7c5d2928@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 26 Jan 2008 04:02:17 +0100
Stefano Brivio <stefano.brivio@polimi.it> wrote:

> Compare adjusted indices with real mac80211 indices instead of internal ones
> while checking them.
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> ---
> John, not sure if this fixes the bug Larry reported, but should applied
> anyway.

John, please discard this as well.


-- 
Ciao
Stefano
