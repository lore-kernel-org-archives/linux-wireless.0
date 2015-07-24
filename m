Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34775 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbbGXOiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 10:38:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 03/13] wil6210: debugfs for channel survey
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1436081080-27305-4-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Fri, 24 Jul 2015 17:38:14 +0300
In-Reply-To: <1436081080-27305-4-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Sun, 5 Jul 2015 10:24:30 +0300")
Message-ID: <87zj2ld3jd.fsf@kamboji.qca.qualcomm.com> (sfid-20150724_163823_892532_9AA3E6E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> Print channel survey results on the debugfs. New entry
> named "survey"
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Why? We have nl80211 command for this, if I understood correctly this
more or less duplicates that functionality?

-- 
Kalle Valo
