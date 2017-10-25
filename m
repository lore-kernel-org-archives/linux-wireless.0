Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:49684 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdJYJHh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 05:07:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Jasmine Strong <jas@eero.com>
CC: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        ath10k <ath10k@lists.infradead.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: rebuild crypto header in Rx data frames
Date: Wed, 25 Oct 2017 09:07:30 +0000
Message-ID: <87d15boasv.fsf@qca.qualcomm.com> (sfid-20171025_110742_202123_90FF8C2E)
References: <1508867652-16199-1-git-send-email-kvalo@qca.qualcomm.com>
        <720ce165-4a06-1d6e-6158-7983d75eea8a@dd-wrt.com>
        <CAGyitvNvCFAfuRg=uKLvZeZVzxsQ14GeXR702FHwu+RLLE_WAQ@mail.gmail.com>
In-Reply-To: <CAGyitvNvCFAfuRg=uKLvZeZVzxsQ14GeXR702FHwu+RLLE_WAQ@mail.gmail.com>       (Jasmine
 Strong's message of "Tue, 24 Oct 2017 14:15:22 -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(fixing top posting)

Jasmine Strong <jas@eero.com> writes:

> On Tue, Oct 24, 2017 at 1:41 PM, Sebastian Gottschall
> <s.gottschall@dd-wrt.com> wrote:
>
>> patch works. tested in sta and ap mode so far on 9984
>
> Seems to work okay on mixed networks of 9882, 4019 and 9888.

Thanks Sebastian and Jasmine for testing this, very much appreciated. We
have a v3 coming up soon which should fix GCMP, GCMP-256 and CCMP-256 as
well.

--=20
Kalle Valo=
