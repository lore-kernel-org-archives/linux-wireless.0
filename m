Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:19887 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab2HIVII (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 17:08:08 -0400
Date: Thu, 9 Aug 2012 17:07:57 -0400
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: decrypt_error flag issue
Message-ID: <20120809170757.748b68bf@mj> (sfid-20120809_230824_256029_7214E717)
In-Reply-To: <CAB=NE6V6T0RMSiMZCsUdr85vWMgs4VfJ6HTYHwf+kDQUwQ-mhg@mail.gmail.com>
References: <CAA2SeNJmaHs5fMHrG65HWbe5Y-ytz2qvuzNGKvhBKgvZ15KoVw@mail.gmail.com>
	<20120809173435.GQ3745@lenteja.do-not-panic.com>
	<CAA2SeNKbBCxPbJmXMyo4-nK2SXL-WcOFQaKDrEM-cxbVrzt7Ew@mail.gmail.com>
	<CAB=NE6V6T0RMSiMZCsUdr85vWMgs4VfJ6HTYHwf+kDQUwQ-mhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 9 Aug 2012 11:10:38 -0700
"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com> wrote:

> And this would lead to .. what? How did you realize this? Can you
> please resend and add all this information to the commit log message?

Also please use a better subject.  For example:

ath9k: fix decrypt_error initialization in ath_rx_tasklet()

"issue" is too vague.

-- 
Regards,
Pavel Roskin
