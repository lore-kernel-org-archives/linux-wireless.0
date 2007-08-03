Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MAIL.IHTFP.ORG ([204.107.200.6]:53124 "EHLO mail.ihtfp.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762054AbXHCPKl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 11:10:41 -0400
To: "John W. Linville" <linville@tuxdriver.com>
Cc: network manager <networkmanager-list@gnome.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Winkler\, Tomas" <tomas.winkler@intel.com>,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] chaning mode only when interface down?
References: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com>
	<1186058047.24230.38.camel@johannes.berg> <46B1D28F.1080006@gmail.com>
	<1186059192.24230.44.camel@johannes.berg>
	<sjmy7gswuvw.fsf@pgpdev.ihtfp.org>
	<20070803145305.GE5137@tuxdriver.com>
From: Derek Atkins <warlord@MIT.EDU>
Date: Fri, 03 Aug 2007 11:10:36 -0400
In-Reply-To: <20070803145305.GE5137@tuxdriver.com> (John W. Linville's message of "Fri\, 3 Aug 2007 10\:53\:05 -0400")
Message-ID: <sjmhcngwt5f.fsf@pgpdev.ihtfp.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> On Fri, Aug 03, 2007 at 10:33:07AM -0400, Derek Atkins wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>> 
>> > On Thu, 2007-08-02 at 14:48 +0200, dragoran wrote:
>> >
>> >> > Nono, you cannot solve it in the driver. The whole design of mac80211
>> >> > mandates that assumption and I think it is a valid one to make.
>> >> why? did the old way (allow mode changing while up) caused any problems?
>> >
>> > Why should it be allowed? Can you come up with a good reason for that
>> > since you lose all state anyway when doing mode transitions?
>> 
>> Um, what state?  Sure you lose your layer 2 state, but why force a
>> layer 3 lossage when you don't necessarily have to do so?  For
>> example, I've seen plenty of networks that have both 802.11(a) and
>> 802.11(b/g) networks that share absolutely everything at layer 3.
>
> I think you are confusing a/b/g "mode" (which is _not_ the topic)
> with AP/STA/IBSS/monitor "mode" (which is the topic).

Indeed I am, mea culpa.   I'll go shut up now.

> John

-derek

-- 
       Derek Atkins, SB '93 MIT EE, SM '95 MIT Media Laboratory
       Member, MIT Student Information Processing Board  (SIPB)
       URL: http://web.mit.edu/warlord/    PP-ASEL-IA     N1NWH
       warlord@MIT.EDU                        PGP key available
