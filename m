Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:50812 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753452AbYCBLQz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 06:16:55 -0500
Date: Sun, 2 Mar 2008 12:04:41 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
Subject: Re: Oops in mac80211:rate_control_pid_tx_status
Message-ID: <20080302120441.26c1b8a3@morte> (sfid-20080302_111737_953629_F4A9C7E8)
In-Reply-To: <2c0942db0803011705j260186bbgb02dcd8f9842e52b@mail.gmail.com>
References: <2c0942db0803011705j260186bbgb02dcd8f9842e52b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 1 Mar 2008 17:05:50 -0800
"Ray Lee" <ray-lk@madrabbit.org> wrote:

> Kernel version 2.6.24+ a little (but pre-rc1).
> 
> I have a wireless base station that I switched from B/G mixed mode to
> purely B to try to debug a separate issue with a different device on
> my network. As soon as I did that (and on every subsequent boot), the
> system oopses as soon as it tries to associate. Switching the base
> station back to "mixed" avoids the oops.

Known and fixed. The fix is in the wireless-testing tree, and I just sent
it rebased against 2.6.25-rc3. Please test:
http://marc.info/?l=linux-wireless&m=120445495012387&w=2


--
Ciao
Stefano
