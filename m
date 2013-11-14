Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:44150 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab3KNJyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 04:54:38 -0500
Received: by mail-la0-f41.google.com with SMTP id hp15so1386455lab.28
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 01:54:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384198356-427-1-git-send-email-rajeshc@qca.qualcomm.com>
References: <1384198356-427-1-git-send-email-rajeshc@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 14 Nov 2013 10:54:15 +0100
Message-ID: <CAB=NE6V7NkXwmvqajqx4ATnCsT9vn=R0JQFkQE5mOdWHWuBsug@mail.gmail.com> (sfid-20131114_105441_687552_81D97656)
Subject: Re: [PATCHv3] cfg80211: add support for frequency interference event
To: Rajesh Chauhan <rajeshc@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"Bahini, Henri" <hbahini@qca.qualcomm.com>,
	Jeff Johnson <jjohnson@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>, sameert@qca.qualcomm.com,
	c_arifh@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 11, 2013 at 8:32 PM, Rajesh Chauhan
<rajeshc@qca.qualcomm.com> wrote:
> Add support for wireless driver to report frequency range(s) to
> be avoided because of interference. Wireless driver specifies
> source of interference for a given frequency range. For now,
> applicable source of interference is "cellular" only and other
> interference source types can be added later. If SoftAP/P2P-GO
> is operating on interfering frequency then user space should stop
> and restart them avoiding interfering frequency range(s). User
> space may decide to continue operation on interfering frequency,
> but in such case, there might be impact on performance.
>
> Signed-off-by: Rajesh Chauhan <rajeshc@qca.qualcomm.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis
