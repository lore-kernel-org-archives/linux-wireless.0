Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:61928 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3IKAcx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 20:32:53 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSX007ZAQT4AY60@mailout1.samsung.com> for
 linux-wireless@vger.kernel.org; Wed, 11 Sep 2013 09:32:52 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: 'Kalle Valo' <kvalo@qca.qualcomm.com>
Cc: "'John W. Linville'" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	'Jingoo Han' <jg1.han@samsung.com>
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
 <00b701ceae18$69cd1860$3d674920$%han@samsung.com>
 <87zjrkibn0.fsf@kamboji.qca.qualcomm.com>
In-reply-to: <87zjrkibn0.fsf@kamboji.qca.qualcomm.com>
Subject: Re: [PATCH 06/12] wireless: ath10k: remove unnecessary
 pci_set_drvdata()
Date: Wed, 11 Sep 2013 09:32:52 +0900
Message-id: <002d01ceae86$7331d760$59958620$%han@samsung.com> (sfid-20130911_023257_292669_056A6863)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, September 11, 2013 6:57 AM, Kalle Valo wrote:
> Jingoo Han <jg1.han@samsung.com> writes:
> 
> > The driver core clears the driver data to NULL after device_release
> > or on probe failure. Thus, it is not needed to manually clear the
> > device driver data to NULL.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Thanks, look good. Do you want me to apply this to my ath.git tree or
> are you planning to send this via some other route?
> 

Hi Kalle Valo,

It would be good that you apply this to your ath.git tree.
Thank you. :-)

Best regards,
Jingoo Han

