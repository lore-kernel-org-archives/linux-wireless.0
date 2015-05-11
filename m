Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36564 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbbEKNYt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 09:24:49 -0400
MIME-Version: 1.0
In-Reply-To: <87vbfzjt4t.fsf@kamboji.qca.qualcomm.com>
References: <20150505224020.GA3805@bytefire-computer> <87wq0ms3mv.fsf@kamboji.qca.qualcomm.com>
 <20150506063241.GA3042@bytefire-computer> <87k2wflj7p.fsf@kamboji.qca.qualcomm.com>
 <2CBE2DDF-92E5-45C9-95F8-C5CF918D12D9@gmail.com> <87vbfzjt4t.fsf@kamboji.qca.qualcomm.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Mon, 11 May 2015 15:24:18 +0200
Message-ID: <CAOiHx=kzSsFenqPSNeAX6P5wJK8Hr-q+s+rJoQQMPbSGmE50xw@mail.gmail.com> (sfid-20150511_152511_791459_3472972E)
Subject: Re: [PATCH 2/2] adm8211: fix the possible pci cache line sizes inside switch-case
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Okash Khawaja <okash.khawaja@gmail.com>,
	"joe@perches.com" <joe@perches.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, May 11, 2015 at 12:38 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Okash Khawaja <okash.khawaja@gmail.com> writes:
>
>> Sure, I'll create v2 of the patch with updated commit log.
>>
>> Since it's part of a patch set, do you want me to send both the
>> patches in the patch set together as v2 or just this patch?
>
> Please resend the whole patchset as v2, less problems that way.

If you are sending a v2 anyway, I'd suggest using decimal values for
the cases, as cache line sizes are usually given in decimal anyway. So
just drop the "0x" instead of converting the values ;-)


Jonas
