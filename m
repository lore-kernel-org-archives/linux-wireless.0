Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.lanforge.com ([66.165.47.211]:42285 "EHLO ns2.lanforge.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbXB0Sks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 13:40:48 -0500
Message-ID: <45E4769E.2040102@candelatech.com>
Date: Tue, 27 Feb 2007 10:21:18 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Jiri Benc <jbenc@suse.cz>,
	Larry Finger <larry.finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Alex Davis <alex14641@yahoo.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: Patch to allow specification of interface name prefix
References: <510326.55988.qm@web50211.mail.yahoo.com>	<20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net>	<45E112F7.9090908@lwfinger.net>	<20070226150241.1b5b63b2@freekitty>	<20070227111644.784600be@logostar.upir.cz> <20070227094108.11f4844f@freekitty>
In-Reply-To: <20070227094108.11f4844f@freekitty>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Hemminger wrote:
> On Tue, 27 Feb 2007 11:16:44 +0100
> Jiri Benc <jbenc@suse.cz> wrote:
> 
>> [removed bcm43xx-dev list]
>>
>> On Mon, 26 Feb 2007 15:02:41 -0800, Stephen Hemminger wrote:
>>> This was hashed out on netdev 2+ years ago and decided that both ethernet
>>> and wireless devices should show up as 'eth%d'. For inclusion d80211 needs to conform
>>> to existing mainline kernel practice. If this means breaking the expectation of older
>>> out of tree wireless support (ie madwifi), sorry.
>> Decided? I remember just you and hch saying "all existing wireless drivers
>> do that, so everybody should". When pointing out that just two drivers do
>> that (I think ipw and prism) and everybody else use something different
>> (wlan%d most often) there was no reply. "ipw and one other driver do that
>> so everybody should" doesn't sound like a strong argument to me.
> 
> Don't put too much stock in what I said. Really don't care about such
> a trivial matter as naming.  Jeff and Christoph seem to care, I don't

Regardless of the name, it would be nice to have some quick way to determine
if a network device is wireless or not.  This could be an IOCTL, something
in /proc/ or similar.  Even if you name them to be wlanX by default, folks
can rename them, so applications that care about the type of the network
device can't key off of names reliably...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

