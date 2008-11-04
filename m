Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:42132 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYKDHVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 02:21:37 -0500
To: "Zhu Yi" <yi.zhu@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.28-rc2-wl: network lockups with iwl3945
References: <871vxuh70u.fsf@nokia.com> <87iqr5ri67.fsf@nokia.com>
	<1225697173.3619.23.camel@johannes.berg>
	<1225698103.2917.312.camel@debian.sh.intel.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 04 Nov 2008 09:21:05 +0200
In-Reply-To: <1225698103.2917.312.camel@debian.sh.intel.com> (ext Zhu Yi's message of "Mon\, 03 Nov 2008 15\:41\:43 +0800")
Message-ID: <87d4hcardq.fsf@nokia.com> (sfid-20081104_082141_322979_4A933A2F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Zhu Yi" <yi.zhu@intel.com> writes:

> On Mon, 2008-11-03 at 15:26 +0800, Johannes Berg wrote:
>> I think this has been fixed for iwlagn recently, but I guess iwl3945
>> will always be forgotten ;)
>
> Yup. Please try attached patch.

Works great. I suspended and resumed five times with wpa_supplicant
running and did not see any problems, 'ip link' command worked always.
Earlier it failed every time after a resume.

Thank you for fixing this. Please push this to wireless-testing.

-- 
Kalle Valo
