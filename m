Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43847 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbZAILMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 06:12:53 -0500
Subject: Re: Fwd: [b43] opensource firmware
From: David Woodhouse <dwmw2@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>
In-Reply-To: <200901091149.28683.mb@bu3sch.de>
References: <200901091129.22708.mb@bu3sch.de>
	 <200901091149.28683.mb@bu3sch.de>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 11:12:49 +0000
Message-Id: <1231499569.28362.1987.camel@macbook.infradead.org> (sfid-20090109_121256_265491_535701DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-09 at 11:49 +0100, Michael Buesch wrote:
> I'd like to start merging this into the "firmware" directory
> of the mainline kernel.

The 'firmware' directory is intended to go away. It only contains the
old firmware which used to be built-in in hex arrays in the source code,
but should never have been.

We have a separate 'linux-firmware' repository, in which we're
collecting new firmwares on top of the stuff we extracted from the
kernel source. That's where we should add the b43 firmware.

-- 
dwmw2

