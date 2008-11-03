Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:37763 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbYKCHpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 02:45:50 -0500
To: "Zhu Yi" <yi.zhu@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.28-rc2-wl: network lockups with iwl3945
References: <871vxuh70u.fsf@nokia.com> <87iqr5ri67.fsf@nokia.com>
	<1225697173.3619.23.camel@johannes.berg>
	<1225698103.2917.312.camel@debian.sh.intel.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 03 Nov 2008 09:44:48 +0200
In-Reply-To: <1225698103.2917.312.camel@debian.sh.intel.com> (ext Zhu Yi's message of "Mon\, 03 Nov 2008 15\:41\:43 +0800")
Message-ID: <87hc6pb6dr.fsf@nokia.com> (sfid-20081103_084554_474505_C44443E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi <yi.zhu@intel.com> writes:

> On Mon, 2008-11-03 at 15:26 +0800, Johannes Berg wrote:
>> I think this has been fixed for iwlagn recently, but I guess iwl3945
>> will always be forgotten ;)
>
> Yup. Please try attached patch.

Thanks! I'm travelling today, but I try to find some free time and an
open AP to test this :)

-- 
Kalle Valo
