Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34007 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbbGXOTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 10:19:48 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH v2 01/13] wil6210: support boot loader struct v0 & v1
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1436168389-3676-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1436168389-3676-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Fri, 24 Jul 2015 17:19:43 +0300
In-Reply-To: <1436168389-3676-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Mon, 6 Jul 2015 10:39:37 +0300")
Message-ID: <87d1zheiyo.fsf@kamboji.qca.qualcomm.com> (sfid-20150724_161952_987504_5D734A8D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> There are 2 versions of boot loader struct: v0 and v1.
> In the v1, boot loader build version added; as well as
> RF status.
>
> Support both versions.
>
> Boot loader structure v1 has RF status; ignore RF error if firmware
> not going to be loaded; driver can still be used to interact with the HW
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

I'll fix this but just so you know:

Importing patch "wil6210-support-boot-loader-st" ... <stdin>:70: new blank line at EOF.
+
warning: 1 line adds whitespace errors.
done

-- 
Kalle Valo




