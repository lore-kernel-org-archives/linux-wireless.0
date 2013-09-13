Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:49778 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab3IMSVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 14:21:12 -0400
Message-ID: <5233575E.6000904@ilande.co.uk> (sfid-20130913_202115_464754_72F3F8CC)
Date: Fri, 13 Sep 2013 19:20:14 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
References: <5232DAF0.6040907@ilande.co.uk> <52330CB4.7020902@ilande.co.uk> <523312D0.3020001@ilande.co.uk> <523352C8.8000902@lwfinger.net>
In-Reply-To: <523352C8.8000902@lwfinger.net>
Subject: Re: rtl8192cu: testing with EdiMax USB
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13/09/13 19:00, Larry Finger wrote:

> Thanks for the info. Eliminating the call to rtl92c_dm_diginit() is a
> very large hammer to attack a small flea, but that points to a potential
> problem.

Glad that it proves useful to you. If you need me to run test patches 
(e.g. logging calculated power values to dmesg), please send them 
through to me off-list and I'll run them and send you back the results.

Given that it could be related to power calculations, another bit of 
information that may help you recreate this is that my desk is really 
close to the AP (probably 10m or a bit less), and so the indicated 
signal strength should be close to maximum.


HTH,

Mark.
