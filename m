Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50936 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab2JMPvQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 11:51:16 -0400
Date: Sat, 13 Oct 2012 17:41:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kalle Valo <kvalo@adurom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset
Message-ID: <20121013154135.GB25810@lst.de> (sfid-20121013_175119_385625_3AD21F12)
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com> <20121011203112.GB3317@kroah.com> <87haq017wi.fsf@purkki.adurom.net> <20121012143355.GA25235@tuxdriver.com> <87a9vr0w4d.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87a9vr0w4d.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 13, 2012 at 08:38:42AM +0300, Kalle Valo wrote:
> * defines inside structures is not common, kernel style is to have the
>   defines on top of the structure definition

I don't think that's true.  At least for code I touch a lot having the
constants close to the field they are for is very common.  That might be
because it actually makes a lot sense and eases writing.   So a big NAK
from me for changing that part.
