Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:42066 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaH2GDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 02:03:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Arend van Spriel <arend@broadcom.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: add testmode
References: <20140828072642.14691.44313.stgit@potku.adurom.net>
	<20140828073041.14691.15099.stgit@potku.adurom.net>
	<878um9ujn1.fsf@kamboji.qca.qualcomm.com>
	<53FEFEDE.5030505@broadcom.com>
Date: Fri, 29 Aug 2014 09:03:09 +0300
In-Reply-To: <53FEFEDE.5030505@broadcom.com> (Arend van Spriel's message of
	"Thu, 28 Aug 2014 12:05:18 +0200")
Message-ID: <87y4u7suhu.fsf@kamboji.qca.qualcomm.com> (sfid-20140829_080318_907290_48ACCE5A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 08/28/14 10:02, Kalle Valo wrote:
>> Kalle Valo<kvalo@qca.qualcomm.com>  writes:
>
>> Johannes suggested to put this to a separate file as that way it's
>> easier for the user space. In v3 I'm planning to create testmode_uapi.h
>> for this.
>
> I suppose that file will/should end up in include/uapi/...

I was thinking not to put this to the include directory. This is just a
testmode interface used only by few people, not a proper driver
interface.

> so wouldn't it be better to call it ath10k_testmode.h?

We already have testmode.h so having ath10k_testmode.h in the same
directory would be confusing. Would testmode_i.h be any better?

-- 
Kalle Valo
