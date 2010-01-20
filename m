Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35655 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab0ATC46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 21:56:58 -0500
Received: by yxe17 with SMTP id 17so5762864yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 18:56:57 -0800 (PST)
Subject: Re: b43 driver hang with bcm4318
From: Eric Volker <evolker@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <69e28c911001191800t23bab697q6354b07656f78a29@mail.gmail.com>
References: <1263951622.3259.26.camel@fwdell4550>
	 <69e28c911001191800t23bab697q6354b07656f78a29@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 20:56:53 -0600
Message-ID: <1263956213.2316.4.camel@fwdell4550>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-01-20 at 03:00 +0100, Gábor Stefanik wrote:
> Please load b43 with verbose debug messages enabled (use the "verbose"
> module parameter - check modinfo for the exact value for full debug
> output), and post the resulting logs.
Loaded b43 with verbose=3 to get debug output. The driver hung much more
quickly with debug output enabled. After about 30 seconds of pinging the
AP became unresponsive, though it was still beaconing. Should I post the
logs to the list, or is there somewhere else they should go?

Thanks,

Eric Volker




