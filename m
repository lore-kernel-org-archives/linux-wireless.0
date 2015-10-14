Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbbJNJmO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 05:42:14 -0400
Date: Wed, 14 Oct 2015 17:42:10 +0800
From: Fengguang Wu <lkp@intel.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	kbuild-all@01.org, linux-kernel@vger.kernel.org
Subject: Re: [kbuild-all] [PATCH] bcma: mips: Allow build if COMPILE_TEST is
 enabled
Message-ID: <20151014094210.GB7743@wfg-t540p.sh.intel.com> (sfid-20151014_114219_634394_97537947)
References: <201510132319.x2UV0LGD%fengguang.wu@intel.com>
 <561E1E69.3070108@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <561E1E69.3070108@osg.samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Javier,

> BTW, 0-day bot used to reports from email address fengguang.wu@intel.com
> but now reports from lkp@intel.com. I still added a Reported-by tag from
> Fengguang Wu <fengguang.wu@intel.com> but I wonder if I should change it
> to kbuild test robot <lkp@intel.com> for future patches?

Either is fine. lkp is my lab account. I have to use it when replying
to mailing list emails because my account does not subscribe to so many
lists.

Thanks,
Fengguang
