Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41812 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbaCJRXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 13:23:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: <ath6kl@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/6] ath6kl: use braces on both arms of if statement
References: <20140309065606.10793.67068.stgit@x230>
	<20140309065717.10793.76274.stgit@x230>
	<1394401348.6972.50.camel@joe-AO722>
Date: Mon, 10 Mar 2014 19:23:00 +0200
In-Reply-To: <1394401348.6972.50.camel@joe-AO722> (Joe Perches's message of
	"Sun, 9 Mar 2014 14:42:28 -0700")
Message-ID: <877g82m0i3.fsf@kamboji.qca.qualcomm.com> (sfid-20140310_182312_737213_BB20718E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Sun, 2014-03-09 at 08:57 +0200, Kalle Valo wrote:
>> Fixes checkpatch warning:
>
> Maybe better to check the bss value and return
> early to save an indent level like:

Yeah, this is better. I'll send a patch to do that.

-- 
Kalle Valo
