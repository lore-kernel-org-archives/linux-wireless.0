Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36847 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbbCSIp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 04:45:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: enable ANI by default
References: <1426701700-21974-1-git-send-email-arnagara@qti.qualcomm.com>
Date: Thu, 19 Mar 2015 10:45:27 +0200
In-Reply-To: <1426701700-21974-1-git-send-email-arnagara@qti.qualcomm.com>
	(Ashok Raj Nagarajan's message of "Wed, 18 Mar 2015 23:31:39 +0530")
Message-ID: <874mphl6jc.fsf@kamboji.qca.qualcomm.com> (sfid-20150319_094602_921589_90BE182C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ashok Raj Nagarajan <arnagara@qti.qualcomm.com> writes:

> ANI is currently not enabled by default. Enable this feature by default.
>
> Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>

You did not send this to ath10k list (and CC linux-wireless). Check the
instructions here:

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/sources#submitting_patches

Also the commit log doesn't tell anything. What is ANI and why should it
be enabled? What bug does this fix (if any)? How will the user see the
difference after this patch is applied?

As a rule of thumb, the commit log should tell any engineer (even one
who is not familiar with ath10k) how the behaviour changes after the
patch is applied. Think of your target group being distro maintainers,
ath10k users, kernel subsystem maintainers etc. No company internal
jargon or anything like that, write in plain english so that everyone
understand.

-- 
Kalle Valo
