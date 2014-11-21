Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:47658 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaKUTGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 14:06:25 -0500
Message-ID: <546F8D2F.2070003@lwfinger.net> (sfid-20141121_200634_217596_8BC657A3)
Date: Fri, 21 Nov 2014 13:06:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-11-21
References: <20141121183014.GA24984@tuxdriver.com>
In-Reply-To: <20141121183014.GA24984@tuxdriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2014 12:30 PM, John W. Linville wrote:
> Dave,
>
> Please pull this batch of updates intended for the 3.19 stream...
>

---snip---

> Larry Finger (3):
>        rtlwifi: Fix setting of tx descriptor for new trx flow
>        rtlwifi: Fix errors in descriptor manipulation
>        rtlwifi: rtl8192se: Fix connection problems

I probably do not understand the update process, but the above 3 patches need to 
be in kernel 3.18, not 3.19.

Thanks,

Larry

