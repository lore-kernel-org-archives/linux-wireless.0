Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:55300 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbAOMDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 07:03:24 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?B?6LCt5p2t5rOi?= <troy_tan@realsil.com.cn>
Cc: "larry.finger" <Larry.Finger@lwfinger.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH for 3.19 3/3] rtlwifi: rtl8192ee: Fix several bugs
References: <1421257036-5382-1-git-send-email-Larry.Finger@lwfinger.net>
	<1421257036-5382-4-git-send-email-Larry.Finger@lwfinger.net>
	<87bnm0xoar.fsf@kamboji.qca.qualcomm.com>
	<C11178B3EB8EC446A461ADCC3E27182146C9AA38@rsex2.realsil.com.cn>
Date: Thu, 15 Jan 2015 14:03:16 +0200
In-Reply-To: <C11178B3EB8EC446A461ADCC3E27182146C9AA38@rsex2.realsil.com.cn>
	(=?utf-8?B?IuiwreadreazoiIncw==?= message of "Thu, 15 Jan 2015 11:51:00
 +0000")
Message-ID: <87twzsw8sb.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_130331_155594_E1D5E78E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

谭杭波 <troy_tan@realsil.com.cn> writes:

> I think a have located the bug reported, but the code
> seems so unclean, so after the bug fix I modified the code 
> and tried to make it more easy to understand.

That's good, but I cannot send cleanup patches to 3.19. Even if the
cleanup fixes something. It's better to do bug fixes and cleanup in
separate patches.

-- 
Kalle Valo
