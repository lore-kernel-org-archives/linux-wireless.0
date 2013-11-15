Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62890 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab3KOOgG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 09:36:06 -0500
Received: from [192.168.1.100] ([79.218.105.41]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0LiTm8-1V9NnN01Ea-00ckxk for
 <linux-wireless@vger.kernel.org>; Fri, 15 Nov 2013 15:36:05 +0100
Message-ID: <52863154.50105@rempel-privat.de> (sfid-20131115_153610_744993_A54E0FBF)
Date: Fri, 15 Nov 2013 15:36:04 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: "Proffit, Jerome" <jproffit@qca.qualcomm.com>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"Biard, David" <dbiard@qca.qualcomm.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc: Target is unresponsive
References: <39E4555519E9C54593B1BE31E24CB79A39B12884@nasanexd02a.na.qualcomm.com> <20131115134752.GQ9795@pogo> <52862D32.3010601@rempel-privat.de> <CAB=NE6VNZDT4JLRM=iqzkaKezXaoaXcXuyTHq62=H-axxGVNZg@mail.gmail.com>
In-Reply-To: <CAB=NE6VNZDT4JLRM=iqzkaKezXaoaXcXuyTHq62=H-axxGVNZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 15.11.2013 15:29, schrieb Luis R. Rodriguez:
> On Fri, Nov 15, 2013 at 3:18 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
>> I do not know which backport include patch for usb interrupt transfer.
> 
> Which patch are you referring to? The backports project releases match
> the Linux kernel releases, so the backports-3.12 release is based on
> linux v3.12, we can check what kernel the patch you are describing got
> merged into Linux by doing:
> 
> git describe --contains gitsum

i mean:

commit 2f5e3ecfc155449987d64028ff6b73f29cd1ef8b
Author: Oleksij Rempel <linux@rempel-privat.de>
Date:   Tue Aug 13 09:29:34 2013 +0200

    ath9k_htc: do not use bulk on EP3 and EP4

If it is already included, then try to revert.

-- 
Regards,
Oleksij
