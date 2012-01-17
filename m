Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53195 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2AQSOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 13:14:45 -0500
Message-ID: <4F15BA40.1060705@qca.qualcomm.com> (sfid-20120117_191448_915754_8B2FCEB7)
Date: Tue, 17 Jan 2012 20:13:20 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 1/8] ath6kl: rename vif init and cleanup functions
References: <20120117180827.29995.67922.stgit@localhost6.localdomain6>
In-Reply-To: <20120117180827.29995.67922.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Doh, forgot to add the cover letter...

But this series is the third version of my ath6kl_core.ko patchset. I
rebased it now on top of ath6kl.git master branch which created some
conflicts and I had to even add a new patch for handling uart debug
parameter. Also in the last patch I add back the USB code John had to
revert during the merge window.

Please review.

Kalle
