Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:34429 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbXLJRP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:15:28 -0500
Received: from [195.4.92.20] (helo=10.mx.freenet.de)
	by mout2.freenet.de with esmtpa (Exim 4.68)
	(envelope-from <lynx.abraxas@freenet.de>)
	id 1J1mE3-0006B8-2T
	for linux-wireless@vger.kernel.org; Mon, 10 Dec 2007 18:15:27 +0100
Received: from obd24.o.pppool.de ([89.51.189.36]:55083 helo=localhost)
	by 10.mx.freenet.de with esmtpsa (ID lynx.abraxas@freenet.de) (TLSv1:AES256-SHA:256) (port 587) (Exim 4.68 #1)
	id 1J1mE1-0005ys-9l
	for linux-wireless@vger.kernel.org; Mon, 10 Dec 2007 18:15:26 +0100
Date: Mon, 10 Dec 2007 18:15:21 +0100
From: lynx.abraxas@freenet.de
To: linux-wireless@vger.kernel.org
Subject: Re: What's wrong if wlan0 device is not reacting?
Message-ID: <20071210171521.GC1475@drago> (sfid-20071210_171531_279935_49FEDBD4)
References: <20071206170858.GA2008@drago> <8e6f94720712061052p105a9e82v290afb011765ba04@mail.gmail.com> <20071206214807.GB1811@drago> <43e72e890712061714i3427f558p9b94390955b0a817@mail.gmail.com> <8e6f94720712071121n234d9d23idaaf49d76b2fe227@mail.gmail.com> <43e72e890712071336v2a4a805eu6aff9ff9c10c9418@mail.gmail.com> <20071208074402.GA2508@drago>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071208074402.GA2508@drago>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/07 08:44:02, lynx.abraxas@freenet.de wrote:
> Checked  this  morning  but I'm still getting errors there. Could I be missing
> some configuration of the build?
> 

Found  the problem: I seem to have gotten a cached tarball which didn't differ
at all. Downloading it with wget got the new one  and  that  compiles  without
problems under 2.6.23.9. I'm sorry for the fuzz.
Well testing the device with the new drivers will have to wait untill January.


Till then, mary Christmas and a happy New Year.
Lynx
