Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37243 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753322AbcJLHi7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 03:38:59 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [v2,1/2] ath10k: clean up HTT tx buffer allocation and free
Date: Wed, 12 Oct 2016 07:35:43 +0000
Message-ID: <87zimaf29d.fsf@kamboji.qca.qualcomm.com> (sfid-20161012_094120_634366_845B0D36)
References: <1475743188-12007-1-git-send-email-mohammed@qca.qualcomm.com>
        <c617b703956d4a038349494b87f65d0a@euamsexm01a.eu.qualcomm.com>
        <20161012070918.GA2993@atheros-ThinkPad-T61>
In-Reply-To: <20161012070918.GA2993@atheros-ThinkPad-T61> (Mohammed Shafi
        Shajakhan's message of "Wed, 12 Oct 2016 12:39:18 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@codeaurora.org> writes:

> Hi Kalle,
>
> On Tue, Oct 11, 2016 at 01:36:22PM +0200, Kalle Valo wrote:
>> Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
>> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>> >=20
>> > cleanup 'ath10k_htt_tx_alloc' by introducing the API's
>> > 'ath10k_htt_tx_alloc/free_{cont_txbuf, txdone_fifo} and
>> > re-use them whereever needed
>> >=20
>> > Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>>=20
>> Applies but fails to build:
>
> [shafi] sorry for the trouble again, I just figured out I had a private p=
atch by
> mistake  and it worked for me, I will make sure that v3 is properly rebas=
ed
> without any errors.

Thanks. And no worries, I now have a script which does commit and build
tests semi-automatically and sends an email if it fails. Yay! This was a
good real life test for the script :)

--=20
Kalle Valo=
