Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37813 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbbC3Jer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 05:34:47 -0400
Received: by wiaa2 with SMTP id a2so120238608wia.0
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2015 02:34:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1427705012.26117.11.camel@sipsolutions.net>
References: <1427433674-5745-1-git-send-email-miaoqing@qca.qualcomm.com> <1427705012.26117.11.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 30 Mar 2015 15:04:26 +0530
Message-ID: <CABPxzYL16NbubDBLcRvtLmPSz8pMezJq627AFSVWyaj41WSxBQ@mail.gmail.com> (sfid-20150330_113452_591422_DEDA1261)
Subject: Re: [PATCH] mac80211: fix failed to set smps
To: Johannes Berg <johannes@sipsolutions.net>
Cc: miaoqing@qti.qualcomm.com, John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 30, 2015 at 2:13 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2015-03-27 at 13:21 +0800, miaoqing@qti.qualcomm.com wrote:
>> From: Miaoqing Pan <miaoqing@qca.qualcomm.com>
>>
>> Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
>
> Since you give no commit log, I can only guess what you're trying to do,
> but I suppose you need to use "echo -n" instead of "echo".
Johannes,

We had this discussion earlier also, i still strongly feel all cases
must work with "echo" by default, as people are not that familiar
to use "echo -n".
