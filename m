Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59468 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbcFHPam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 11:30:42 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Prasun Maiti <prasunmaiti87@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	Linux Next <linux-next@vger.kernel.org>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Add .set_antenna callback in ath6kl driver to remove
 wireless core warns
Date: Wed, 8 Jun 2016 15:30:37 +0000
Message-ID: <87d1nrk89v.fsf@kamboji.qca.qualcomm.com> (sfid-20160608_173105_329306_4151DFE9)
References: <1465388474-20503-1-git-send-email-prasunmaiti87@gmail.com>
	<87wplzkbd9.fsf@kamboji.qca.qualcomm.com>
	<CAEO8o4=DnEfXQAnAOxugC9TngbhvgV9DXz0HOVHNLk0B2fAXQA@mail.gmail.com>
	<87porrkaax.fsf@kamboji.qca.qualcomm.com>
	<CAEO8o4kD7MU09o+xOwPLn-PAgcuMExQ0MbNWgqv0fOs61rG8Xw@mail.gmail.com>
In-Reply-To: <CAEO8o4kD7MU09o+xOwPLn-PAgcuMExQ0MbNWgqv0fOs61rG8Xw@mail.gmail.com>	(Prasun
 Maiti's message of "Wed, 8 Jun 2016 20:50:40 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prasun Maiti <prasunmaiti87@gmail.com> writes:

> I am not sure it works fine. Like ath6kl driver send another cmd to
> firmare, I have just filled up the cmd buffer with "tx_ant", and
> "rx_ant" values, then use "ath6kl_wmi_cmd_send()" api to send the cmd
> buffer to firmware. I have resend the patch as there are some errors
> in the previous patch. Let me know if any modifications are needed?

I don't take untested code. In some special cases it might be ok to send
untested code but even then it needs to be clearly stated in the commit
log that it's untested.

Please resend once you have tested this, I'm dropping this now.

-- 
Kalle Valo