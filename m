Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:23708 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3IZFzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 01:55:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath10k: implement firmware IE container support
References: <20130925210455.2596.36889.stgit@localhost6.localdomain6>
	<20130925210848.2596.56332.stgit@localhost6.localdomain6>
	<CA+BoTQ=BhtjC1YNLs9OYBPN6TiYhyrwYoK2A1wifS01HVJp1YA@mail.gmail.com>
Date: Thu, 26 Sep 2013 08:55:07 +0300
In-Reply-To: <CA+BoTQ=BhtjC1YNLs9OYBPN6TiYhyrwYoK2A1wifS01HVJp1YA@mail.gmail.com>
	(Michal Kazior's message of "Thu, 26 Sep 2013 07:46:16 +0200")
Message-ID: <878uykunyc.fsf@kamboji.qca.qualcomm.com> (sfid-20130926_075523_453537_3E392ED0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Did you skip board file intentionally?

Yes, because my understanding is that the board file is not tied to any
particular firmware version. The board file should be specific to the
hardware configuration in use, or at least that's how it is with ath6kl.

-- 
Kalle Valo
