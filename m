Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38674 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbcHCLmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 07:42:20 -0400
Received: by mail-wm0-f42.google.com with SMTP id o80so331957132wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2016 04:41:41 -0700 (PDT)
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com>
 <20160721070938.GA2658@redhat.com>
 <CANUX_P3ADxi+RHkH=d8Ypcqy9WVKSu4JYH7K3HtTNCuWg3wCeQ@mail.gmail.com>
 <20160721080541.GB2658@redhat.com> <5790A28F.8030102@redhat.com>
 <20160721115122.GA31869@redhat.com>
 <a264e995-fc46-7fcd-69f9-80992385b6b1@broadcom.com>
 <20160722102559.GA2662@redhat.com> <20160722221523.GM5537@wotan.suse.de>
 <874m738m02.fsf@kamboji.qca.qualcomm.com>
 <20160802141610.GJ3296@wotan.suse.de>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Prarit Bhargava <prarit@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ming Lei <ming.lei@canonical.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>,
	"mmarek@suse.com" <mmarek@suse.com>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	Arend van Spriel <arend@broadcom.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ae734397-6179-d0ba-3d8a-0cffc63a0fd8@broadcom.com> (sfid-20160803_134225_257664_F85CDB81)
Date: Wed, 3 Aug 2016 13:33:31 +0200
MIME-Version: 1.0
In-Reply-To: <20160802141610.GJ3296@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02-08-16 16:16, Luis R. Rodriguez wrote:
> On Tue, Aug 02, 2016 at 11:10:22AM +0000, Valo, Kalle wrote:
>> "Luis R. Rodriguez" <mcgrof@kernel.org> writes:
>>
>>> I was considering this as a future extension to the firmware API
>>> through the new extensible firmware API, the sysdata API.
>>
>> I think Linus mentioned this already, but I want to reiterate anyway.
>> The name "sysdata" is horrible, I didn't have any idea what it means
>> until I read your description. Please continue to use the term
>> "firmware", anyone already know what it means.
> 
> We've gone well past using the firmware API for firmware though, if
> we use it for 802.11 to replace CRDA for instance its really odd to
> be calling it firmware. But sure... I will rebrand again to firmware...

I tend to agree. Although some people even call an OpenWrt image
firmware. Guess it is just in the eye of the beholder.

Regards,
Arend
