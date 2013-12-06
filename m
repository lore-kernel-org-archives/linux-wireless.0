Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34326 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3LFOAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 09:00:16 -0500
Date: Fri, 6 Dec 2013 08:57:19 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [net 5/5] rfkill: Fix FSF address in file headers
Message-ID: <20131206135718.GB13285@tuxdriver.com> (sfid-20131206_150030_104177_1EF10E01)
References: <1386329534-21739-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <1386329534-21739-5-git-send-email-jeffrey.t.kirsher@intel.com>
 <1386330604.4456.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1386330604.4456.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 06, 2013 at 12:50:04PM +0100, Johannes Berg wrote:
> On Fri, 2013-12-06 at 03:32 -0800, Jeff Kirsher wrote:
> > Several files refer to an old address for the Free Software Foundation
> > in the file header comment.  Resolve by replacing the address with
> > the URL <http://www.gnu.org/licenses/> so that we do not have to keep
> > updating the header comments anytime the address changes.
> 
> Looks good to me, I guess you want me to pick it up?
> 
> Or John - do you just want to pick up the series?
> 
> johannes

I'll just take the series.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
