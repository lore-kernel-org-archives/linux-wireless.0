Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:32877 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbcB2Xur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 18:50:47 -0500
Received: by mail-ig0-f195.google.com with SMTP id hb3so707346igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 29 Feb 2016 15:50:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <wrfjio17hyco.fsf@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
 <1456783551-28315-67-git-send-email-Jes.Sorensen@redhat.com>
 <CAGRGNgW+QS6dgYdvJgWQ+qKjLWHC-U1Ni7LAQUK0VXuJiQu2aA@mail.gmail.com> <wrfjio17hyco.fsf@redhat.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 1 Mar 2016 10:50:26 +1100
Message-ID: <CAGRGNgU-Y05b1_G8pKctNEoBX3=nX+CFNi=djzO6iA6EesBUpA@mail.gmail.com> (sfid-20160301_005052_024765_74EA7146)
Subject: Re: [PATCH 066/113] rtl8xxxu: Call device specific _config_channel()
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jes,

On Tue, Mar 1, 2016 at 10:48 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Julian Calaby <julian.calaby@gmail.com> writes:
>> Hi Jes,
>>
>> On Tue, Mar 1, 2016 at 9:05 AM,  <Jes.Sorensen@redhat.com> wrote:
>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>
>>> Having a version for the newer chips without calling it doesn't do
>>> much good.....
>>>
>>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Should this be squashed into the patch that introduces the new op?
>
> I can start rewriting history, but all that comes out of that is having
> to fight patch conflicts rebasing things.
>
> If there was an actual functional reason for it, sure, but in this case
> there isn't.

Fair enough, it just looks odd to have fixes like this in a patch
series that almost entirely consists of introducing new stuff.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
