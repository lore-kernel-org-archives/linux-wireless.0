Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33302 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbcC3MAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 08:00:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wei-Ning Huang <wnhuang@google.com>
Cc: sedat.dilek@gmail.com,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Daniel Kurtz <djkurtz@chromium.org>, snanda@chromium.org,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH RESEND] mwifiex: fix NULL pointer dereference error
References: <1459332895-4563-1-git-send-email-wnhuang@chromium.org>
	<CA+icZUVpMU0kjEKPpABU415Gv_EhFUkAGbXi82UVf8PbHnz9mw@mail.gmail.com>
	<CABicQ-Wwf6LrFujVw03TNvAF-ny4d2MfqP+GDL0ARRkg5EnT3Q@mail.gmail.com>
Date: Wed, 30 Mar 2016 15:00:22 +0300
In-Reply-To: <CABicQ-Wwf6LrFujVw03TNvAF-ny4d2MfqP+GDL0ARRkg5EnT3Q@mail.gmail.com>
	(Wei-Ning Huang's message of "Wed, 30 Mar 2016 18:38:31 +0800")
Message-ID: <871t6sb2g9.fsf@kamboji.qca.qualcomm.com> (sfid-20160330_140046_985960_5A1156E0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei-Ning Huang <wnhuang@google.com> writes:

> Kalle, can you help amend the message if this patch is accepted?

Sure, I'll fix the typo in the commit log.

But please try to avoid top posting, it makes it more difficult to
follow the threads.

-- 
Kalle Valo
