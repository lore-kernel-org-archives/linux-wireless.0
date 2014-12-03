Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:51534 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaLCOFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 09:05:16 -0500
Received: by mail-qc0-f181.google.com with SMTP id m20so11219841qcx.12
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2014 06:05:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <878uipl2dl.fsf@kamboji.qca.qualcomm.com>
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
	<878uipl2dl.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 3 Dec 2014 08:05:15 -0600
Message-ID: <CAP+RiCDFPX0r82eNwoNPv=YrE3xjfAztH_VghVNa__UKzKZBQA@mail.gmail.com> (sfid-20141203_150521_327573_91699EAB)
Subject: Re: Laptop disassociating by local choice (reason=17)
From: Brent Taylor <motobud@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	ath6kl@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 2, 2014 at 11:37 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Brent Taylor <motobud@gmail.com> writes:
>
>> On Dec 2, 2014 11:24 PM, "Kalle Valo" <kvalo@qca.qualcomm.com> wrote:
>>>
>>> Brent Taylor <motobud@gmail.com> writes:
>>>
>>> >    I actually ran the wpa_supplicant with -ddddt as the parameter not
>>> > knowing how many 'd's I could put there before I hit the limit of the
>>> > debugging.  The wpa_supplicant on the ubuntu laptop is v0.7.3.  I'll
>>> > change the -ddddt to just -dddt and re-run the test again.
>>>
>>> IMHO 0.7.3 is ancient. Please use something more recent.
>>
>> Ancient it may be, but why would it work with the ath9k chip and not
>> the ath6kl chip?
>
> Because of a bug we are not aware of? ath6kl and ath9k are very
> different drivers and 0.7.3 might have some problem which only comes
> with ath6kl. Up to you, but I would not waste time testing on that old
> wpasupplicant.
>
> --
> Kalle Valo

Apologies for my last reply not making it through the mailing lists, I
sent it from my phone and it was automatically formatted in HTML and
not Plain Text.

The ultimate goal is to use an Android device to communicate with my
custom device being the Access Point.  The laptop is easier to debug
(at the moment) than an Android device.  I'm currently using a Samsung
S4 running 4.4.4 and it was not able to complete the authentication
step either.  This is when I turned to using the laptop.  Any idea
what version of the wpa_supplicant is running on Kit Kat?

-- Brent Taylor
