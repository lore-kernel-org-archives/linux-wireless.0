Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35544 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbcFHPql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 11:46:41 -0400
MIME-Version: 1.0
In-Reply-To: <87d1nrk89v.fsf@kamboji.qca.qualcomm.com>
References: <1465388474-20503-1-git-send-email-prasunmaiti87@gmail.com>
 <87wplzkbd9.fsf@kamboji.qca.qualcomm.com> <CAEO8o4=DnEfXQAnAOxugC9TngbhvgV9DXz0HOVHNLk0B2fAXQA@mail.gmail.com>
 <87porrkaax.fsf@kamboji.qca.qualcomm.com> <CAEO8o4kD7MU09o+xOwPLn-PAgcuMExQ0MbNWgqv0fOs61rG8Xw@mail.gmail.com>
 <87d1nrk89v.fsf@kamboji.qca.qualcomm.com>
From: Prasun Maiti <prasunmaiti87@gmail.com>
Date: Wed, 8 Jun 2016 21:16:39 +0530
Message-ID: <CAEO8o4=XEr4DQC3bqAXGE01s5WC+kuZ3PqoJFtuSCE52RNyDzA@mail.gmail.com> (sfid-20160608_174704_294075_F079ACFD)
Subject: Re: [PATCH] Add .set_antenna callback in ath6kl driver to remove
 wireless core warns
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please tell me if I mention that this code is untested in commit log,
then could you check the code kindly and also help me to fix this type
of warning?

On Wed, Jun 8, 2016 at 9:00 PM, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
> Prasun Maiti <prasunmaiti87@gmail.com> writes:
>
>> I am not sure it works fine. Like ath6kl driver send another cmd to
>> firmare, I have just filled up the cmd buffer with "tx_ant", and
>> "rx_ant" values, then use "ath6kl_wmi_cmd_send()" api to send the cmd
>> buffer to firmware. I have resend the patch as there are some errors
>> in the previous patch. Let me know if any modifications are needed?
>
> I don't take untested code. In some special cases it might be ok to send
> untested code but even then it needs to be clearly stated in the commit
> log that it's untested.
>
> Please resend once you have tested this, I'm dropping this now.
>
> --
> Kalle Valo



-- 
Thanks,
Prasun
