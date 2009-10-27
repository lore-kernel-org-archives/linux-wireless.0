Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:55160 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbZJ0ShQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 14:37:16 -0400
Received: by iwn8 with SMTP id 8so347075iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2009 11:37:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ACE131E.3080908@lwfinger.net>
References: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com>
	<4ACE131E.3080908@lwfinger.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 27 Oct 2009 11:37:01 -0700
Message-ID: <43e72e890910271137l31082c41t7e62a82e901d3456@mail.gmail.com>
Subject: Re: Prism54/p54pci
To: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: James Grossmann <cctsurf@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 8, 2009 at 9:28 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 10/07/2009 04:00 PM, James Grossmann wrote:
>>
>> I have the gigafast WF728-AEX, which doesn't seem to work with the
>> p54pci drivers, I was previously using it with my Thinkpad T23 under
>> Gentoo (gentoo kernels 2.6.29 and 2.6.30), and could only use the
>> 1.0.4.3 firmware, now, I am using it under Ubuntu 9.04
>> (2.6.28-15-generic kernel) on the same computer, and find that I have
>> to load the prism54 driver to make it work.
>> I noticed that you were considering this to be depricated, I hope that
>> you can help me to make p54pci work!
>
> As it works with 2.6.29 and 2.6.30 kernels, but not with 2.6.28, it seems
> likely that you need a later version of the driver. Does Ubuntu have a
> package for compat-wireless? If so, install it. If not, you will need to
> install from source.

James, please do test with a new driver and appropriate firmware and
let us know if it worked or not.

  Luis
