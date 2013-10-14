Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:60608 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab3JNOG1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 10:06:27 -0400
Received: by mail-oa0-f41.google.com with SMTP id n10so4595696oag.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 07:06:27 -0700 (PDT)
Date: Mon, 14 Oct 2013 09:06:25 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Ben Meiselman <benmeiselman@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	Yonah Meiselman <yonah.meiselman@gmail.com>
Subject: Re: [Ilw] trouble with wireless AC 7260 in ubuntu 13.04
Message-ID: <20131014140625.GA9363@thinkpad-t410> (sfid-20131014_160637_113896_16035215)
References: <CAHpj=KC=eRafrM4+bxO+nGg4UBCkV1toyei4HL_s+Svd_3BrtA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DC1C5A@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301DC1C5A@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 13, 2013 at 04:49:27AM +0000, Grumbach, Emmanuel wrote:
> Hi,
> 
> First, please note that mails in any other format than plaintext won't go through the filters to the mailing list. So please, hit the plain text button in gmail.
> 
> 
> > Hello supporters,
> 
> :) 
> 
> > I got your email addresses from here: http://wireless.kernel.org/en/users/Drivers/iwlwifi
> > (Also copying my brother on this email.)
> 
> > I installed Ubuntu 13.04 on a new machine. It has an Intel Dual Band AC 7260 wireless card. I would like to connect to a wireless network but don't know how.
> > I put iwlwifi-7260-7.ucode into /lib/firmware
> 
> I am not sure if Ubuntu 13.04 supports this new device already. I'd ask Seth Forshee (CCed).
> This device is supported starting from kernel 3.10 which AFAIK is not shipped with Ubuntu 13.04. They may very well have added a backport based driver.

Ubuntu 13.04 is using a 3.8 kernel. We'll be using 3.11 in the 13.10
release, which is due out this month. If you don't want to install a
newer kernel yourself you can either update to the 13.10 beta [1] or use
the backports project to get drivers from later kernels [2].

Seth

[1] http://fridge.ubuntu.com/2013/09/27/ubuntu-13-10-saucy-salamander-final-beta-released/
[2] https://backports.wiki.kernel.org

