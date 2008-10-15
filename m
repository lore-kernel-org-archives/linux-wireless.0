Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:3377 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYJOTQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 15:16:50 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1317009nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 12:16:47 -0700 (PDT)
Message-ID: <48F6419B.80104@gmail.com> (sfid-20081015_211655_986602_D08CE33B)
Date: Wed, 15 Oct 2008 20:16:43 +0100
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: arvidjaar@mail.ru, linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-10-14
References: <20081015013204.GH3349@tuxdriver.com>
In-Reply-To: <20081015013204.GH3349@tuxdriver.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Here is a nice little batch of wireless fixes in time for 2.6.28-rc1.
> There are also a few USB ID additions as well.  I think this is all
> mostly obvious, and hopefully still acceptable at this stage.
> 
> Please let me know if there are problems!

> Andrey Borzenkov (1):
>       orinoco: fix unsafe locking in orinoco_cs_resume

Hi John,

Just wanted to check whether you'd seen/intend to apply the orinoco patch Andrey posted in <http://marc.info/?l=linux-kernel&m=122365972026045&w=4>. It fixes a regression (vs 2.6.26) when using 4k stacks.

Or whether you'd prefer that patch resent with an updated subject?


Regards,

Dave.
