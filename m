Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52906 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbZCFOpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 09:45:30 -0500
Date: Fri, 6 Mar 2009 09:36:12 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: tim.gardner@canonical.com,
	reinette chatre <reinette.chatre@intel.com>,
	"stable@kernel.org" <stable@kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Please apply to stable: cfg80211: add support for custom
	firmware regulatory solutions
Message-ID: <20090306143612.GA3712@tuxdriver.com> (sfid-20090306_154534_609293_CA6968E8)
References: <43e72e890903041335n47a70186u4a7aeb304f8b6979@mail.gmail.com> <1236275668.6612.134.camel@rc-desk> <43e72e890903051124t42ce5c7blfd741da4a2b4fa79@mail.gmail.com> <49B056FA.2020605@canonical.com> <43e72e890903051513n44cf5281y32cc11e06754aa3@mail.gmail.com> <49B06DA6.7070000@canonical.com> <43e72e890903051633w7880648djdd798c5a28285a6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890903051633w7880648djdd798c5a28285a6b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 05, 2009 at 04:33:37PM -0800, Luis R. Rodriguez wrote:
> On Thu, Mar 5, 2009 at 4:26 PM, Tim Gardner <tim.gardner@canonical.com> wrote:

> > What is the downside of just turning OLD_REG back on for 2.6.28?
> 
> You default to the "US" regulatory domain so channels 12-14 will not
> be available by default. This is also why we offloaded regulatory crap
> to userspace in the first place, so you won't have to upgrade your
> kernel based on reg changes or fixes.
> 
> I'll send a patch to enable passive scan on channels 12-14 for the
> world regulatory domain. That and the 5 GHz patch should at least let
> you see channels 12-14 with a fix from userspace. This can also go
> into 28 for the world regulatory domain and since it would be fixing
> an issue maybe we should consider it.
> 
> Thoughts John?

Honestly I don't think it is worth swizzling -stable for this.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
