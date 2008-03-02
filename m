Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:44739 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbYCBRRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 12:17:36 -0500
Received: by nf-out-0910.google.com with SMTP id g13so3069782nfb.21
        for <linux-wireless@vger.kernel.org>; Sun, 02 Mar 2008 09:17:35 -0800 (PST)
Message-ID: <2c0942db0803020917r3e9985fi626b238c89731921@mail.gmail.com> (sfid-20080302_171741_072629_3A3F942F)
Date: Sun, 2 Mar 2008 09:17:34 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Stefano Brivio" <stefano.brivio@polimi.it>
Subject: Re: Oops in mac80211:rate_control_pid_tx_status
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <20080302120441.26c1b8a3@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2c0942db0803011705j260186bbgb02dcd8f9842e52b@mail.gmail.com>
	 <20080302120441.26c1b8a3@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 2, 2008 at 3:04 AM, Stefano Brivio <stefano.brivio@polimi.it> wrote:
> On Sat, 1 Mar 2008 17:05:50 -0800
>  "Ray Lee" <ray-lk@madrabbit.org> wrote:
>
>  > Kernel version 2.6.24+ a little (but pre-rc1).
>  >
>  > I have a wireless base station that I switched from B/G mixed mode to
>  > purely B to try to debug a separate issue with a different device on
>  > my network. As soon as I did that (and on every subsequent boot), the
>  > system oopses as soon as it tries to associate. Switching the base
>  > station back to "mixed" avoids the oops.
>
>  Known and fixed. The fix is in the wireless-testing tree, and I just sent
>  it rebased against 2.6.25-rc3. Please test:
>  http://marc.info/?l=linux-wireless&m=120445495012387&w=2

Will do. Thanks!
