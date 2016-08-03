Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37623 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345AbcHCPKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 11:10:08 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
CC: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Prarit Bhargava <prarit@redhat.com>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	Ming Lei <ming.lei@canonical.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>,
	"mmarek@suse.com" <mmarek@suse.com>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	Arend van Spriel <arend@broadcom.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
Date: Wed, 3 Aug 2016 15:04:39 +0000
Message-ID: <87ziot51x9.fsf@qca.qualcomm.com> (sfid-20160803_171056_458529_CA77E077)
References: <CANUX_P3ADxi+RHkH=d8Ypcqy9WVKSu4JYH7K3HtTNCuWg3wCeQ@mail.gmail.com>
	<20160721080541.GB2658@redhat.com> <5790A28F.8030102@redhat.com>
	<20160721115122.GA31869@redhat.com>
	<a264e995-fc46-7fcd-69f9-80992385b6b1@broadcom.com>
	<20160722102559.GA2662@redhat.com>	<20160722221523.GM5537@wotan.suse.de>
	<874m738m02.fsf@kamboji.qca.qualcomm.com>
	<20160802141610.GJ3296@wotan.suse.de>
	<ae734397-6179-d0ba-3d8a-0cffc63a0fd8@broadcom.com>
	<20160803142119.GL3296@wotan.suse.de>
In-Reply-To: <20160803142119.GL3296@wotan.suse.de> (Luis R. Rodriguez's
	message of "Wed, 3 Aug 2016 16:21:19 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@kernel.org> writes:

> On Wed, Aug 03, 2016 at 01:33:31PM +0200, Arend van Spriel wrote:
>> On 02-08-16 16:16, Luis R. Rodriguez wrote:
>> > On Tue, Aug 02, 2016 at 11:10:22AM +0000, Valo, Kalle wrote:
>> >> "Luis R. Rodriguez" <mcgrof@kernel.org> writes:
>> >>
>> >>> I was considering this as a future extension to the firmware API
>> >>> through the new extensible firmware API, the sysdata API.
>> >>
>> >> I think Linus mentioned this already, but I want to reiterate anyway.
>> >> The name "sysdata" is horrible, I didn't have any idea what it means
>> >> until I read your description. Please continue to use the term
>> >> "firmware", anyone already know what it means.
>> > 
>> > We've gone well past using the firmware API for firmware though, if
>> > we use it for 802.11 to replace CRDA for instance its really odd to
>> > be calling it firmware. But sure... I will rebrand again to firmware...
>> 
>> I tend to agree. Although some people even call an OpenWrt image
>> firmware. Guess it is just in the eye of the beholder.
>
> Sure...
>
> Come to think of it I'll still go with "sysdata", this is a very minor
> detail, do let me know if there is anything technical rather than
> the color of the bikeshed [0] over the patches.

Well, you don't seem to care but I prefer that the terminology is clear
and I don't want to waste people's time browsing the source to find out
what something means. Even "driverdata" would be more descriptive for me
than "sysdata".

Actually, what does the "sys" refer here, system? And what system is
that exactly?

-- 
Kalle Valo