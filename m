Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52792 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab1HKMbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 08:31:07 -0400
Received: by ywf7 with SMTP id 7so1255516ywf.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 05:31:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313063838.2407.852.camel@cumari>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	<1313063838.2407.852.camel@cumari>
Date: Thu, 11 Aug 2011 15:31:06 +0300
Message-ID: <CAB3XZEcpWrXxm9TfHjLO260LH8bAr2_FMsiBfhwRyb8BKcuxpw@mail.gmail.com> (sfid-20110811_143110_772347_2DABC4C3)
Subject: Re: [PATCH 00/40] wl12xx: move to wl12xx-fw-3
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 11, 2011 at 2:57 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote:
>> The new wl12xx fw (ver 7.3.0.0.75) had some major api changes.
>> The main change was the addition of multi-role concept, which
>> will later allow using multiple vifs concurrently.
>>
>> Consequently, this design change caused api changes for most
>> of the api commands, as a new role_id had to be added.
>>
>> This patchset migrates the fw to use the new fw api (a new
>> fw filename is used, as there is no backward compatability
>> with older firmwares).
>
> Okay, I'm done with my review! Lots of small nitpicking, but this in
> general looks very good! Thanks a lot for the good work, guys!
>
thanks a lot for your review.
i'm working on fixing all the issues, and i'll resubmit.

Eliad.
