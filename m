Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:28917 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033AbbA2KRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 05:17:12 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: implement sta keepalive command
References: <1421749440-10457-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 29 Jan 2015 12:16:59 +0200
In-Reply-To: <1421749440-10457-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 20 Jan 2015 11:23:59 +0100")
Message-ID: <87vbjp3n8k.fsf@kamboji.qca.qualcomm.com> (sfid-20150129_111721_319213_CE259A4F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> New wmi-tlv firmware for qca6174 has STA keepalive
> service available. The service can provide
> automatic idle connection polling via NullFunc
> frames to AP when acting as a client.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, both patches applied to ath.git.

-- 
Kalle Valo
