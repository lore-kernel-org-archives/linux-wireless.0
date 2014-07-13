Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:51585 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaGMQrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 12:47:40 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so3148276wes.13
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 09:47:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53C25FB1.7030802@openwrt.org>
References: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1405246704-7489-10-git-send-email-lorenzo.bianconi83@gmail.com>
	<53C25FB1.7030802@openwrt.org>
Date: Sun, 13 Jul 2014 18:47:39 +0200
Message-ID: <CAA2SeN+vmh-bg8uh4srJVzixYK2ZauALdJvdimw6ZPbebDtcjw@mail.gmail.com> (sfid-20140713_184743_964425_A7B7227D)
Subject: Re: [ath9k-devel] [RFCv2 09/10] ath9k: disable dynack algorithm when
 coverage class is set
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 2014-07-13 12:18, Lorenzo Bianconi wrote:
>> Disable ack timeout estimation algorithm if the coverage class has been
>> configured
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> I think this is broken, since it doesn't allow you to re-enable dynack
> through the same way as it was disabled.
> I would recommend adding an 'auto' value for coverage class.

Ok. Could we use 255 as 'auto' value? Did you mean something else?
According to the standard maximum value for coverage class is 31, isn't it?

>
> - Felix

Best regards,

Lorenzo


-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
