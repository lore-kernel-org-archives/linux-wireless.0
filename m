Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37780 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbcA2A4Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 19:56:25 -0500
MIME-Version: 1.0
In-Reply-To: <20160127233220.GA28541@kroah.com>
References: <CAL7P5j+iYzpnR+xT013A7AV=bQ8bSn4W1K=qjieFCAiv1YmwRw@mail.gmail.com>
 <20160125181220.GJ5325@mwanda> <87r3h2ubcp.fsf@purkki.adurom.net>
 <CAGRGNgVzbBGBOko-YG7h7rX+ZZHeKa5XHM3x+zdqz9mHX7nfRg@mail.gmail.com>
 <20160127230700.GA13701@kroah.com> <CAGRGNgU6-saYqZ-LAHjq9cNeptYo8OR-GZQ-66Bv5DDnYi3k5g@mail.gmail.com>
 <20160127233220.GA28541@kroah.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 29 Jan 2016 11:56:04 +1100
Message-ID: <CAGRGNgXUHsHSnH5dD7a3uBa=AQCYz+Zc2icbf56+suAeuf9msw@mail.gmail.com> (sfid-20160129_015639_079649_F93754A4)
Subject: Re: Move wlan-ng out of staging?
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	=?UTF-8?Q?Ksenija_Stanojevi=C4=87?= <ksenija.stanojevic@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

On Thu, Jan 28, 2016 at 10:32 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Jan 28, 2016 at 10:28:38AM +1100, Julian Calaby wrote:
>> Hi Greg,
>>
>> On Thu, Jan 28, 2016 at 10:07 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Thu, Jan 28, 2016 at 09:48:16AM +1100, Julian Calaby wrote:
>> >> Hi Glen,
>> >>
>> >> On Thu, Jan 28, 2016 at 5:27 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> >> > Dan Carpenter <dan.carpenter@oracle.com> writes:
>> >> >
>> >> >> On Mon, Jan 25, 2016 at 01:16:56PM +0100, Ksenija Stanojević wrote:
>> >> >>> Hi All,
>> >> >>>
>> >> >>> I'm helping Greg do a bit of cleanup in the staging tree, I noticed that
>> >> >>> wlan-ng driver is maybe ready to be moved out of staging. Are there
>> >> >>> any TODO tasks left to do beside checkpatch.pl clean-up?
>> >> >
>> >> > For questions like this you should CC linux-wireless.
>> >> >
>> >> >> I happened to look through this code recently.  It's terrible.
>> >> >
>> >> > And uses wireless extensions, yuck. There's a lot of work to get it into
>> >> > reasonable shape, fixing checkpatch warnings will not be enough.
>> >>
>> >> On the same subject, the wilc1000 driver has taken some pretty big
>> >> steps in the past few days, how far away do you think it is from
>> >> graduating from staging?
>> >
>> > I have 221 patches in my to-apply queue to be merged for this driver, at
>> > the very least, those need to be merged before anyone should review it
>> > for graduation.  That number also implies that there is still quite a
>> > lot to be done, but I would not know for sure until that happens.
>>
>> I figured that was the case (there's a _lot_ of churn on that driver)
>> however I've noticed the patches recently have swung away from being
>> straight checkpatch / coding style cleanups towards feature additions
>> and bug fixes, hence my question.
>
> Please feel free to audit it and let us know the details :)

After looking at the latest round of patches, I take back my comment:
it's not ready.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
