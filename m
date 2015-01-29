Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56810 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbbA2WAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 17:00:21 -0500
Received: by mail-wi0-f169.google.com with SMTP id h11so16457893wiw.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2015 14:00:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422566048629.36984@mail.polimi.it>
References: <1422566048629.36984@mail.polimi.it>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 30 Jan 2015 03:30:00 +0530
Message-ID: <CABPxzYJOT1OMapkL3Yy-wJmDA0T-iNryF-V_RqYE==9pO1CHTA@mail.gmail.com> (sfid-20150129_230024_794284_915457CA)
Subject: Re: "iw": two small questions
To: Stefano Cappa <stefano.cappa@mail.polimi.it>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 30, 2015 at 2:44 AM, Stefano Cappa
<stefano.cappa@mail.polimi.it> wrote:
>
> Hi, i've two question about iw
>
> 1) It's possibile that "iw phy phy0 info" said that i can use a particular combination of interfaces in "Valid interface combinations" but on my device i can't use this combination? If yes, the problem is with the driver of this device?
>
> 2) How iw obtains the information to print "Valid interface combinations"? iw asks this information to the driver/hardware/or something else ?
>

Yes, it talks to the device driver and gets the combinations which the
device supports.
