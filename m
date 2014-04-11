Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63617 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaDKFrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 01:47:45 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so2007927wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2014 22:47:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8738hkh193.fsf@kamboji.qca.qualcomm.com>
References: <53461A8A.4030209@candelatech.com>
	<1397124355-6321-1-git-send-email-michal.kazior@tieto.com>
	<8738hkh193.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 11 Apr 2014 07:47:44 +0200
Message-ID: <CA+BoTQ=gUBsw43M2at0y7iZU3VhwdjH9EBqzdOmKpxLjjqusPw@mail.gmail.com> (sfid-20140411_074750_739870_BA582697)
Subject: Re: [PATCH] ath10k: double check bmi xfer pointers
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 April 2014 07:40, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> If for some reason copy engine ring buffer became
>> corrupt ath10k could crash the machine due to
>> invalid pointer dereference. It's very unlikely
>> but devices can never be fully trusted so verify
>> if the bmi xfer pointer read back from copy engine
>> matches the original pointer.
>
> The big question is why does this happen? Does this happen only with
> Ben's firmware or is it a more generic problem?

I'll look more into this.


Michał
