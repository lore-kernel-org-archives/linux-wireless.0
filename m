Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:50329 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752806AbYDMXMN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 19:12:13 -0400
Date: Mon, 14 Apr 2008 01:11:51 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFT] b43legacy: fix initvals loading on bcm4303
Message-ID: <20080414011151.76c4203e@polimi.it> (sfid-20080414_001216_010717_EC5D270C)
In-Reply-To: <20080406171053.62008810@polimi.it>
References: <20080406171053.62008810@polimi.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 6 Apr 2008 17:10:53 +0200
Stefano Brivio <stefano.brivio@polimi.it> wrote:

> This allows for the correct initial values to be uploaded to bcm4303
> devices. It should be correct, but I can't reliably test this as I suspect
> there's something going wrong with an hardware rfkill switch on my laptop.
> Please test.
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> ---
> [...]

John, please go ahead with this, as it makes bcm4303 devices partially
working.

Thanks.


--
Ciao
Stefano
