Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40791 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbYLORPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 12:15:24 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 09:15:24 -0800
Date: Mon, 15 Dec 2008 01:15:43 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ionut Radu <ionut.radu@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: The latest archive is missing ath5k driver
Message-ID: <20081215091543.GD6162@tesla> (sfid-20081215_181527_474685_E705EC62)
References: <99a2c9180812131604v41109e2ckc5c76f8f415ae8c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <99a2c9180812131604v41109e2ckc5c76f8f415ae8c9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 13, 2008 at 04:04:26PM -0800, Ionut Radu wrote:
> Hi,
> 
> I have installed the compat-wireless-2008-12-11, but I couldn't find
> the ath5k driver :
> 
> ionut@mendol:~/compat-wireless-2008-12-11$ sudo modprobe ath5k
> FATAL: Module ath5k not found.
> ionut@mendol:~/compat-wireless-2008-12-11$ sudo athload ath5k
> Module ath_pci not detected -- this is fine
> FATAL: Module ath5k not found.
> ionut@mendol:~/compat-wireless-2008-12-11$
> 
> 
> What's wrong?

Did the compile go through fine? Did you sudo make install?

modprobe -l ath5k

  Luis
