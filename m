Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46740 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbbBOOzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 09:55:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Pat Erley <pat-lkml@erley.org>,
	"Fu\, Zhonghui" <zhonghui.fu@linux.intel.com>,
	<brudley@broadcom.com>, Franky Lin <frankyl@broadcom.com>,
	<meuleman@broadcom.com>, <linville@tuxdriver.com>,
	<pieterpg@broadcom.com>, <hdegoede@redhat.com>, <wens@csie.org>,
	<linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>, <netdev@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] brcmfmac: avoid duplicated suspend/resume operation
References: <54DC1D7D.5050407@linux.intel.com>
	<54E0072D.3020802@linux.intel.com> <54E01209.7010300@erley.org>
	<54E05961.7000201@broadcom.com>
Date: Sun, 15 Feb 2015 16:54:52 +0200
In-Reply-To: <54E05961.7000201@broadcom.com> (Arend van Spriel's message of
	"Sun, 15 Feb 2015 09:31:29 +0100")
Message-ID: <878ufzi5s3.fsf@kamboji.qca.qualcomm.com> (sfid-20150215_155532_393792_75F1E0D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 02/15/15 04:27, Pat Erley wrote:
>> On 02/14/2015 08:40 PM, Fu, Zhonghui wrote:
>>>
>>> Any comments to this patch? Can it be accepted?
>
> I assume that patches are queued up until after the merge window that
> we are currently in.

That's right. In the future I will most likely apply patches also during
the merge window, but as I'm still a greenhorn I'll be on the safe and
wait for the merge window to end.

-- 
Kalle Valo
