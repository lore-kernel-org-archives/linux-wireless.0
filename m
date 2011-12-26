Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55923 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab1LZNH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 08:07:57 -0500
Message-ID: <4EF87199.2050207@qca.qualcomm.com> (sfid-20111226_140818_858443_8FF587B6)
Date: Mon, 26 Dec 2011 18:37:37 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, Paul Stewart <pstew@google.com>
Subject: Re: [PATCH] mac80211: use RCU read locks for sta_info_get
References: <1324882778-3079-1-git-send-email-mohammed@qca.qualcomm.com> <201112261151.05309.chunkeey@googlemail.com>
In-Reply-To: <201112261151.05309.chunkeey@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Christian,

On Monday 26 December 2011 04:21 PM, Christian Lamparter wrote:
> On Monday 26 December 2011 07:59:38 Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> Cc: Paul Stewart<pstew@google.com>
>> Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
> huh, where did I sign that off? Anyway, You [or John?] can drop that line
> and replace it with Cc: stable@kernel.org

i will send a proper v2 and this is being recently added by the commit 
a85e1d55974646a442d95911e3f7d7a891ea9ac5, i will properly mention it 
also. thank you


>
> Regards,
> 	Chr

