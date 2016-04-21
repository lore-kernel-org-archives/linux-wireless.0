Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slowthinkers.net ([82.95.118.26]:42975 "EHLO
	density.slowthinkers.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbcDUUV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 16:21:29 -0400
From: Anne Marcel Roorda <marcel@density.slowthinkers.net>
To: Seth Forshee <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [wireless-regdb] wireless-regdb: Update regulatory rules for Germany (DE) on 5GHz
In-reply-to: <20160421185134.GD95003@ubuntu-hedt>
References: <1958820.LBuzOElZFT@perisens15> <20160421131938.GA95003@ubuntu-hedt> <2919568.ssjlN6KUVX@perisens15> <20160421185134.GD95003@ubuntu-hedt>
Date: Thu, 21 Apr 2016 22:13:14 +0200
Message-Id: <20160421201315.9C536206F0@density.slowthinkers.net> (sfid-20160421_222132_761738_9BD10C93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 21 Apr 2016, Seth Forshee wrote:
> On Thu, Apr 21, 2016 at 08:08:46PM +0200, Maximilian Engelhardt wrote:
>
>> The comments to my initial mail indicated that the statement in the ERC 
>> recommendation I linked are alone not enough to add this frequency ranges for 
>> other countries. Unfortunately I don't have the possibility to do these checks 
>> for countries other than Germany.
>
>Yep, I understand and am in agreement. I know how challenging it can be
>to try to track down this information.

  I could do the same for NL.

  At the moment entries for NL are listed as center frequencies
(almost, 5490 - 5710 @ 160 should be 5550 - 5645 @ 160), while for DE
the whole band is listed (5470 - 5725 @ 160).

  Power budget is listed in db while the law specifies mW.

  What is the prefered format, and would a rewrite for NL listing the band
and power in mW be acceptable ?

Thanks,

- marcel
