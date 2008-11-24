Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48965 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751602AbYKXCpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 21:45:04 -0500
Subject: Re: iwlagn MAC in deep sleep
From: Zhu Yi <yi.zhu@intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Mike Kershaw <dragorn@kismetwireless.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4270E0F0-BE5E-4448-A6B0-2E74113488F6@holtmann.org>
References: <20081121193348.GA7373@drd1813.lan>
	 <1227491716.2548.213.camel@debian.sh.intel.com>
	 <4270E0F0-BE5E-4448-A6B0-2E74113488F6@holtmann.org>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 10:45:24 +0800
Message-Id: <1227494724.2548.223.camel@debian.sh.intel.com> (sfid-20081124_034511_562550_8EA2F49E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-11-24 at 10:34 +0800, Marcel Holtmann wrote:
> > Can you please look for something called vPRO/AMT in your BIOS and
> > try to disable it?
> 
> what has that to do with it? You need to explain why this should help
> at all. Just randomly enabling/disabling features of your core system
> is not a good debugging method. And even if that makes this go away,  
> it is still a bug that needs fixed.

iwlagn currently doesn't support AMT, which is another user for the same
hardware. At this time, the only way we can do is to disable it.

BTW, I assume you ask this question on behalf of other people. Otherwise
you should involve in our internal discussion as active as the external
ones.

Thanks,
-yi

