Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57261 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaARKFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jan 2014 05:05:34 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: fix the MAC address of peer statistic
References: <1389345564-21042-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQmexjQy-+Bv-uofBa2Ndcu56yYOAEeNzdBSE3yMCQdZKw@mail.gmail.com>
	<87d2jqrajq.fsf@kamboji.qca.qualcomm.com>
	<CAEFj984ojBbfsMVi3VCQYcRqk2rMz+sq_MaH9JbDsuEmks0DTQ@mail.gmail.com>
Date: Sat, 18 Jan 2014 12:05:29 +0200
In-Reply-To: <CAEFj984ojBbfsMVi3VCQYcRqk2rMz+sq_MaH9JbDsuEmks0DTQ@mail.gmail.com>
	(Yeoh Chun-Yeow's message of "Sat, 18 Jan 2014 17:53:18 +0800")
Message-ID: <878uudob9y.fsf@kamboji.qca.qualcomm.com> (sfid-20140118_110538_129285_D2F18FEA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeoh Chun-Yeow <yeohchunyeow@gmail.com> writes:

>> This reminds me that Bartosz sent something related to this few months back:
>>
>> http://lists.infradead.org/pipermail/ath10k/2013-September/000317.html
>>
>
> Thanks, Michal and Kalle Valo for both your comments
>
> I just would like to know which version of firmware should we use?

It depends what you want to do. 10.1 firmare supports AP mode best, but
other modes are not supported or are otherwise buggy.

The main firmware "999.x" supports all modes, but AP mode support is not
that good as in 10.1.

-- 
Kalle Valo
