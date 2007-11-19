Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:40778 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752134AbXKSQeb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 11:34:31 -0500
Date: Mon, 19 Nov 2007 17:33:35 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <larry.finger@lwfinger.net>, mb@bu3sch.de,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [resend] [PATCH] remove bcm43xx
Message-ID: <20071119173335.6bda8dba@morte> (sfid-20071119_163435_970965_55786BDC)
In-Reply-To: <20071119172750.36aea945@morte>
References: <20071119172750.36aea945@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 19 Nov 2007 17:27:50 +0100
Stefano Brivio <stefano.brivio@polimi.it> wrote:

> John,
> this is for 2.6.25 - in case you didn't get the full patch. Please also
> run: git rm -r drivers/wireless/bcm43xx

git rm -r drivers/net/wireless/bcm43xx, of course. :)


-- 
Ciao
Stefano
