Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:54683 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab1EKCiM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 22:38:12 -0400
To: Greg KH <gregkh@suse.de>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath6kl: iw dev wlan0 link implementation
References: <20110511020257.1752.97603.stgit@localhost6.localdomain6>
	<20110511022309.GA8427@suse.de>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 11 May 2011 05:38:09 +0300
In-Reply-To: <20110511022309.GA8427@suse.de> (Greg KH's message of "Tue\, 10 May 2011 19\:23\:09 -0700")
Message-ID: <87hb92ezce.fsf@purkki.adurom.net> (sfid-20110511_043827_062812_B22B3636)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH <gregkh@suse.de> writes:

>> +	static const s32 legacy[] = { 1000, 2000, 5500, 11000,
>> +				      6000, 9000, 12000, 18000, 24000,
>> +				      36000, 48000, 54000 };
>> +	u8 i;
>> +
>> +	for (i = 0; i < 12; i++) {
>
> Please use ARRAY_SIZE for this, and your other loop variables to ensure
> that you got it right.

Good point, I missed that. I'll send v3.

Thanks.

-- 
Kalle Valo
