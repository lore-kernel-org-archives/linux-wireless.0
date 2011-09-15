Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42222 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935365Ab1IOXWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 19:22:06 -0400
Received: by qyk7 with SMTP id 7so3601570qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 16:22:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316128877.12897.6.camel@Joe-Laptop>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
 <1316112414-6341-9-git-send-email-wey-yi.w.guy@intel.com> <1316115470.11236.1.camel@Joe-Laptop>
 <1316112830.19293.4.camel@wwguy-huron> <1316116047.11236.8.camel@Joe-Laptop>
 <1316127246.7631.2.camel@wwguy-ubuntu> <1316128469.12897.4.camel@Joe-Laptop>
 <CAB=NE6Uyib_ZRRRZ76FGTD6WiVtATrb33-D00s=9tO=SevD8LA@mail.gmail.com> <1316128877.12897.6.camel@Joe-Laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 15 Sep 2011 16:21:46 -0700
Message-ID: <CAB=NE6UTbQnVYZ6awdsQ=gibHRj2eYPE18LJupQRcUpEhA0nvA@mail.gmail.com> (sfid-20110916_012344_009200_5A7A88F1)
Subject: Re: [PATCH] iwlagn: Convert kzalloc to kcalloc
To: Joe Perches <joe@perches.com>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 15, 2011 at 4:21 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2011-09-15 at 16:18 -0700, Luis R. Rodriguez wrote:
>> On Thu, Sep 15, 2011 at 4:14 PM, Joe Perches <joe@perches.com> wrote:
>> > On Thu, 2011-09-15 at 15:54 -0700, wwguy wrote:
>> >> On Thu, 2011-09-15 at 12:47 -0700, Joe Perches wrote:
>> >> > Convert kzalloc to kcalloc, coalesce multiple lines too.
>> >> IIRC, there is no real different between kcalloc and kzalloc, I think
>> >> kcalloc will call kzalloc; both zero out the memory before return.
>> > Multiplication overflow protection.
>> Then the patch should explain that, no?
>
> Egads.  I think not.  It's trivially obvious.

So obvious the maintainer had to ask.

  Luis
