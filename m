Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:32672 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752144AbeAZK1X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 05:27:23 -0500
Subject: Re: [PATCH 0/4] ath9k: AR9003 noise floor calibration support
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com
References: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
 <87o9ll57ps.fsf@kamboji.qca.qualcomm.com>
 <b9553f06-b190-c6ec-bb85-587984abfee0@dd-wrt.com>
From: Wojciech Dubowik <wojciech.dubowik@neratec.com>
Message-ID: <ed47cefe-efa4-a7c9-d017-b50a99316f43@neratec.com> (sfid-20180126_112726_989702_FA805A07)
Date: Fri, 26 Jan 2018 11:27:20 +0100
MIME-Version: 1.0
In-Reply-To: <b9553f06-b190-c6ec-bb85-587984abfee0@dd-wrt.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I will try it with again with couple of OEM cards.

Is nanostation calibrated for noisefloor? You can see it with 
modal_eeprom in debugfs.

Wojtek
On 26/01/18 10:59, Sebastian Gottschall wrote:
> i dont know if this is a coincidence. but after testing your patch on 
> a standard ubiquiti nanostation m2 the noise floor looks wrong.
> it will stay on -112 which is clearly impossible in 2.4 (before it was 
> around -96)
