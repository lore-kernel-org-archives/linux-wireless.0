Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22720 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbbCMQIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 12:08:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] ath10k: add basic tdls support
References: <1425905138-9966-1-git-send-email-marek.puzyniak@tieto.com>
	<CADnKcVi-we6TSPMNgboS5B9ead7Xiv+tukNZhEiboN+Eb_x6Vg@mail.gmail.com>
Date: Fri, 13 Mar 2015 18:08:24 +0200
In-Reply-To: <CADnKcVi-we6TSPMNgboS5B9ead7Xiv+tukNZhEiboN+Eb_x6Vg@mail.gmail.com>
	(Marek Puzyniak's message of "Wed, 11 Mar 2015 13:38:49 +0100")
Message-ID: <87fv98ribr.fsf@kamboji.qca.qualcomm.com> (sfid-20150313_170838_231327_26332B18)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> On 9 March 2015 at 13:45, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
>> This patchset introduces tdls funtionality without tdls peer uapsd
>> and tdls channel switching. Tdls is supported by qca6174 hardware
>> what is indicated by firmware through supported services.
> [...]
>> Marek Puzyniak (2):
>>   ath10k: make peer type configurable
>>   ath10k: introduce basic tdls functionality
>>
>> Michal Kazior (1):
>>   ath10k: unify tx mode and dispatch
> [...]
>
> Kalle, please drop this patchset. I will send new version.

Ok, dropped.

-- 
Kalle Valo
