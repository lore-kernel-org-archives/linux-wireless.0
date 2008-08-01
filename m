Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:40395 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbYHAVnd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 17:43:33 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1270362rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 14:43:32 -0700 (PDT)
Message-ID: <1ba2fa240808011443u1a5553fpfca046f047773217@mail.gmail.com> (sfid-20080801_234350_543114_E8855B5A)
Date: Sat, 2 Aug 2008 00:43:32 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-2.6 2008-08-01
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080801205830.GA10071@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080801205830.GA10071@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 1, 2008 at 11:58 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> Dave,
>
> Another big batch of wireless fixes for 2.6.27.  The ath5k series is
> more than fixes, but I included it because it enables new ath5k
> hardware.  (The ath5k.h changes in particular are documentation cleanups
> for registers based on info gleaned from the newly posted ath9k driver.)
> The others patches are fixes, some more obvious than others. :-)
>
> Let me know if there are any problems!

All the iwlwifi patches should go up otherwise the support for 5000 HW
will be incomplete.
Tomas.
