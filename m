Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43365 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946131AbcBRNW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 08:22:29 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.van@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless dependency
References: <CAF7Mx6rQrsxkm1g9O6-dkzQPLgV0X3yb5TakrOU316Xy-bU1pw@mail.gmail.com>
Date: Thu, 18 Feb 2016 15:22:22 +0200
In-Reply-To: <CAF7Mx6rQrsxkm1g9O6-dkzQPLgV0X3yb5TakrOU316Xy-bU1pw@mail.gmail.com>
	(Arend Van Spriel's message of "Mon, 15 Feb 2016 11:16:49 +0100")
Message-ID: <87egcarw4x.fsf@kamboji.qca.qualcomm.com> (sfid-20160218_142232_929732_0545B679)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.van@broadcom.com> writes:

> I am preparing a patch series for wireless-drivers-next, but there is
> a dependency with patch that was submitted to wireless-drivers [1].
> How should I handle this. Can I submit it for wireless-drivers-next as
> well?
>
> [1] https://patchwork.kernel.org/patch/8061031/

Commiting the same patch twice is not acceptable. I think the easiest is
that you submit the dependency patches separately and document in patch
(after "---" line) or in the cover letter what commits you need from
wireless-drivers and why. I can then merge wireless-drivers to
wireless-drivers-next.

-- 
Kalle Valo
