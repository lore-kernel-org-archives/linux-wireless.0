Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:31838 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbbJVGej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 02:34:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yan Bellavance <ybellavance@tamaggo.com>
CC: "ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>,
	"c_manoha@qca.qualcomm.com" <c_manoha@qca.qualcomm.com>,
	Bartosz Markowski <bartosz.markowski@tieto.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>,
	Marek Puzyniak <marek.puzyniak@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: QCA6174, is it ath6kl or ath10k?
References: <BY2PR15MB0197D5CFB773E0A3F4B6062FA3380@BY2PR15MB0197.namprd15.prod.outlook.com>
Date: Thu, 22 Oct 2015 09:34:15 +0300
In-Reply-To: <BY2PR15MB0197D5CFB773E0A3F4B6062FA3380@BY2PR15MB0197.namprd15.prod.outlook.com>
	(Yan Bellavance's message of "Wed, 21 Oct 2015 20:41:05 +0000")
Message-ID: <87wpuf8l94.fsf@kamboji.qca.qualcomm.com> (sfid-20151022_083442_765846_47761DD2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yan Bellavance <ybellavance@tamaggo.com> writes:

> I would like to know if the QCA6174 should be driven by ath6kl driver or
> ath10k.  I'm working with snapdragon 810 devkit and it looks like it's using
> ath6kl based driver but official linux documentation and github point out that
> it should be driven by ath10k.

What makes you think you should use ath6kl with QCA6174? Please provide
details.

> Could someone explain to me what are the differences between the two(briefly
> and in the context of QCA61x4) and if there are drawbacks to using the ath6kl
> one?

ath10k and ath6kl are drivers for different chipsets, you cannot just
choose with one to use. I don't understand why you think you can choose
as you can't.

> Why are we not using ath10k driver?

With QCA6174 you have to use ath10k.

-- 
Kalle Valo
