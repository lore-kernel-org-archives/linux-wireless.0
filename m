Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:64970 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbaIJJQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 05:16:33 -0400
MIME-Version: 1.0
In-Reply-To: <CANUX_P3kOetqEneHgqoCDN4c85SQYD-G=mQj_o1c_TvKmE5psA@mail.gmail.com>
References: <20140908191630.GB29412@tuxdriver.com>
	<540F5927.7000306@hartkopp.net>
	<CANUX_P3n0v1SzfbYuaAsE4TY7Hz_wo2Fb9SmHVNyFOC9hDhwdg@mail.gmail.com>
	<540F61D0.9000704@hartkopp.net>
	<CAMw6YJLeO1JZeY6hNe-TXOS56b-otk+htt5VPPor+9iYCQz53Q@mail.gmail.com>
	<540FDB3C.6060301@hartkopp.net>
	<CANUX_P3kOetqEneHgqoCDN4c85SQYD-G=mQj_o1c_TvKmE5psA@mail.gmail.com>
Date: Wed, 10 Sep 2014 12:16:32 +0300
Message-ID: <CAMw6YJKgVVnDrn1X7atemC1r9kwvsr3PQDs4qx5KDeeNy-P3VA@mail.gmail.com> (sfid-20140910_111643_772505_78E51E33)
Subject: Re: iwlwifi no authentication with AP - Re: pull request:
 wireless-next 2014-09-08
From: Vadim Kochan <vadim4j@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Your patch works for me.

On Wed, Sep 10, 2014 at 11:24 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Wed, Sep 10, 2014 at 8:01 AM, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>> On 10.09.2014 00:07, Vadim Kochan wrote:
>>> I have the same issue with iwlwifi.
>>
>> I tried an old zd1211 wireless USB stick to check if this problem is 80211
>> related. But the USB stick works fine (I'm using it right now).
>> So its definitely looks like an iwlwifi issue.
>>
>>> iwlwifi 0000:02:00.0: fail to flush all tx fifo queues Q 0
>>
>> Wasn't there any change in the iwlwifi tx path recently??
>
> Can you please try the patch attached? It works for me.
>
>>
>> Regards,
>> Oliver
>>
>>>
