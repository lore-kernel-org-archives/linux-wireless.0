Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:36709 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913AbYDFPaA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2008 11:30:00 -0400
Message-ID: <47F8EC74.7000802@lwfinger.net> (sfid-20080406_163007_812940_22B18378)
Date: Sun, 06 Apr 2008 10:29:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefano Brivio <stefano.brivio@polimi.it>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43legacy: fix bcm4303 crash
References: <20080406170507.16992935@polimi.it>
In-Reply-To: <20080406170507.16992935@polimi.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano Brivio wrote:
> This fixes an hard crash which happened upon driver loading on bcm4303 rev.
> 2 devices.
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> ---
> John, this is for 2.6.26.

Shouldn't this be for 2.6.25?

Larry

