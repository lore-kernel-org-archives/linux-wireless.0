Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32455 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaLCFiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 00:38:23 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Brent Taylor <motobud@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	<ath6kl@lists.infradead.org>
Subject: Re: Laptop disassociating by local choice (reason=17)
References: <CAP+RiCBDAi7e6vj5vvrcEpt17JicdmPwq16zhG9Fun11HfnBkw@mail.gmail.com>
	<CAP+RiCDMerG_8EYi=0Ta3BvAwuWinNPYuNevjF85w08HsX4f2Q@mail.gmail.com>
	<CABPxzY+oxDH7QysFNWQg6fMWpsQDSFm5YgOusaz0KibEnH++yQ@mail.gmail.com>
	<CAP+RiCCD7EefqNKKXonrvd9T3G=+4aKZQXe0QbXBKKCzHvgAzQ@mail.gmail.com>
	<CABPxzY+Eimssqcxs0W79_5zGBHmFnrTc5+qeTnmYr_UH_9ti6A@mail.gmail.com>
	<CAP+RiCC4KmgNMGCiCzDeL_0-frGw7acoZf5FDv4OTmauQPU5Hw@mail.gmail.com>
	<1417563128.32003.8.camel@dcbw.local>
	<CAP+RiCD2vtZyVOTykKwBcm12g8mpPKc8ZBWUgFL90TU0C5ciUw@mail.gmail.com>
	<87h9xdl30j.fsf@kamboji.qca.qualcomm.com>
	<CAP+RiCCE1Z96z6+YX=Cfnb0O3vGdnZeivJH5T3XQ5DWbCbbH_w@mail.gmail.com>
Date: Wed, 3 Dec 2014 07:37:58 +0200
In-Reply-To: <CAP+RiCCE1Z96z6+YX=Cfnb0O3vGdnZeivJH5T3XQ5DWbCbbH_w@mail.gmail.com>
	(Brent Taylor's message of "Tue, 2 Dec 2014 23:31:13 -0600")
Message-ID: <878uipl2dl.fsf@kamboji.qca.qualcomm.com> (sfid-20141203_063826_359946_799DCBBB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brent Taylor <motobud@gmail.com> writes:

> On Dec 2, 2014 11:24 PM, "Kalle Valo" <kvalo@qca.qualcomm.com> wrote:
>>
>> Brent Taylor <motobud@gmail.com> writes:
>>
>> >    I actually ran the wpa_supplicant with -ddddt as the parameter not
>> > knowing how many 'd's I could put there before I hit the limit of the
>> > debugging.  The wpa_supplicant on the ubuntu laptop is v0.7.3.  I'll
>> > change the -ddddt to just -dddt and re-run the test again.
>>
>> IMHO 0.7.3 is ancient. Please use something more recent.
>
> Ancient it may be, but why would it work with the ath9k chip and not
> the ath6kl chip?

Because of a bug we are not aware of? ath6kl and ath9k are very
different drivers and 0.7.3 might have some problem which only comes
with ath6kl. Up to you, but I would not waste time testing on that old
wpasupplicant.

-- 
Kalle Valo
