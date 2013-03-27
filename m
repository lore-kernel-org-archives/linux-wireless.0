Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37523 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab3C0Uwd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 16:52:33 -0400
Message-ID: <51535B08.2000708@openwrt.org> (sfid-20130327_215309_987901_17BF54EE)
Date: Wed, 27 Mar 2013 21:48:08 +0100
From: John Crispin <blogic@openwrt.org>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: make the driver build for Ralink SoC
References: <1363808915-14278-1-git-send-email-blogic@openwrt.org> <3D4497AD-8992-47D6-BCF2-5D738B6AC9B4@gmail.com> <514AB846.9090407@openwrt.org> <20130327171713.GD1868@tuxdriver.com> <515339AB.30609@openwrt.org> <AC53EE34-1306-490A-9BB3-290434C08D1C@gmail.com>
In-Reply-To: <AC53EE34-1306-490A-9BB3-290434C08D1C@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>>> Any more word on this?
>> Gabor posted a series as RFC that would fix this properly ->
>>
>> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2013-March/005837.html
> Yeah, and that series looks good. Unfortunately, it is too intrusive to still apply for 3.9.
>
> John L., could we get in a scheme where we apply John C.'s patch for 3.9 and then use Gabor's series for 3.10?
> Don't know how that works with making sure that this patch is reverted for 3.10.
>
> Can you coordinate, or should I help you with this?
>
Hi,

if we could apply my original 'dirty' patch as a temporary fix for 3.9, 
that would be great. Its not an optimal solution but it at least makes 
the code compile/work.

Gabor and myself have also accumulated a pile of other patches. In 
addition to the 8 patch series that splits the pci/generic code, there 
is a 20 patch series, that adds rt3662/rt3883 support, a 7 patch series 
that adds rt5350 support and another 8 patches that add OF support.

I am planning to setup a git tree with all these after easter and then 
send them to the list for review. Ideally these patches all make it into 
3.10 as we will also be merging the remaining Ralink SoC patches via the 
linux-mips tree for 3.10 (with the exception of the ethernet driver as 
it will need a rewrite before I can send it upstream)

     John


