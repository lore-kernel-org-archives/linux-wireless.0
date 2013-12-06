Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3LFLuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:50:12 -0500
Message-ID: <1386330604.4456.0.camel@jlt4.sipsolutions.net> (sfid-20131206_125018_567229_27CEAC32)
Subject: Re: [net 5/5] rfkill: Fix FSF address in file headers
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 06 Dec 2013 12:50:04 +0100
In-Reply-To: <1386329534-21739-5-git-send-email-jeffrey.t.kirsher@intel.com> (sfid-20131206_123257_671306_3F814CA2)
References: <1386329534-21739-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <1386329534-21739-5-git-send-email-jeffrey.t.kirsher@intel.com>
	 (sfid-20131206_123257_671306_3F814CA2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-12-06 at 03:32 -0800, Jeff Kirsher wrote:
> Several files refer to an old address for the Free Software Foundation
> in the file header comment.  Resolve by replacing the address with
> the URL <http://www.gnu.org/licenses/> so that we do not have to keep
> updating the header comments anytime the address changes.

Looks good to me, I guess you want me to pick it up?

Or John - do you just want to pick up the series?

johannes

