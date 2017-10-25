Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:43932 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932253AbdJYJ2I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 05:28:08 -0400
Subject: Re: [PATCH v2] ath10k: rebuild crypto header in Rx data frames
To: Kalle Valo <kvalo@qca.qualcomm.com>, Jasmine Strong <jas@eero.com>
Cc: ath10k <ath10k@lists.infradead.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1508867652-16199-1-git-send-email-kvalo@qca.qualcomm.com>
 <720ce165-4a06-1d6e-6158-7983d75eea8a@dd-wrt.com>
 <CAGyitvNvCFAfuRg=uKLvZeZVzxsQ14GeXR702FHwu+RLLE_WAQ@mail.gmail.com>
 <87d15boasv.fsf@qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <2d87e371-33e7-2918-e149-40311e32b7f6@dd-wrt.com> (sfid-20171025_112900_473759_9B28F799)
Date: Wed, 25 Oct 2017 11:28:04 +0200
MIME-Version: 1.0
In-Reply-To: <87d15boasv.fsf@qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 25.10.2017 um 11:07 schrieb Kalle Valo:
> (fixing top posting)
>
> Jasmine Strong <jas@eero.com> writes:
>
>> On Tue, Oct 24, 2017 at 1:41 PM, Sebastian Gottschall
>> <s.gottschall@dd-wrt.com> wrote:
>>
>>> patch works. tested in sta and ap mode so far on 9984
>> Seems to work okay on mixed networks of 9882, 4019 and 9888.
> Thanks Sebastian and Jasmine for testing this, very much appreciated. We
> have a v3 coming up soon which should fix GCMP, GCMP-256 and CCMP-256 as
> well.

i have my own v3, but will wait for your version to check how much its 
different from mine

i'm also able to test gmp / aes 256 using 2 QCA 9984 devices


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
