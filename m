Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:56094 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbbAOMPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 07:15:54 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 17/22] wil6210: add advanced interrupt moderation
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1419320844-23989-18-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<87mw5vt3fb.fsf@kamboji.qca.qualcomm.com>
	<54AE770C.4080006@qca.qualcomm.com>
Date: Thu, 15 Jan 2015 14:15:47 +0200
In-Reply-To: <54AE770C.4080006@qca.qualcomm.com> (Vladimir Kondratiev's
	message of "Thu, 8 Jan 2015 14:24:44 +0200")
Message-ID: <87iog8w87g.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_131557_677002_EE5A6790)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> On 01/07/2015 10:12 AM, Kalle Valo wrote:
>> The number of module parameters feels a little excessive, especially
>> when you add one more in the following patch. Is it really necessary for
>> the user to configure all these? Why can't the driver pick good
>> defaults?
>
> Unfortunately, all these are really tunable parameters that impact
> performance. I also realized it is too much. If we will find
> appropriate defaults for some parameters, not requiting tuning, I'll
> upload patch removing it.

Ok, fair enough. But in the future please try to think twice before
using module parameters. They should not be abused by having too many of
them.

-- 
Kalle Valo
