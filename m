Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:35239 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab2ASTNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 14:13:13 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Dave Jones <davej@redhat.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: Dan Williams <dcbw@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: RE: iwlwifi worse than ever in current git.
Date: Thu, 19 Jan 2012 19:12:37 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB30799F5@HASMSX103.ger.corp.intel.com> (sfid-20120119_201323_640554_66C51EDE)
References: <20120110184917.GA26973@redhat.com>
 <1326221614.5067.6.camel@dcbw.foobar.com>
 <0BA3FCBA62E2DC44AF3030971E174FB3063085@HASMSX103.ger.corp.intel.com>
 <20120111014243.GA22066@redhat.com>
 <0BA3FCBA62E2DC44AF3030971E174FB306429E@HASMSX103.ger.corp.intel.com>
 <20120111195055.GA5140@redhat.com>
 <0BA3FCBA62E2DC44AF3030971E174FB3064AF5@HASMSX103.ger.corp.intel.com>
 <CANUX_P3UHz-Pr_M1H5pAbmKDY70es7nxkWSDGXG6-hvrPAMCJw@mail.gmail.com>
 <20120119182955.GA1630@redhat.com>
In-Reply-To: <20120119182955.GA1630@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Thu, Jan 19, 2012 at 08:47:28AM +0200, Emmanuel Grumbach wrote:
>  > Ok, I finally had a change to take a closer look at this. Please run
>  > with debug=0xC0000000.
>  >
>  > This will be noisy, but I guess we have no choice...
>  > I will be travelling next week, so...
> 
> Ah. Got it. I had to do a large download (a kernel tarball was enough) to
> trigger it.
> Log is at http://davej.fedorapeople.org/iwl-debug.txt
> 
> The download began at around 13:17 in the log.
> It hung shortly afterwards.
> 
> 	Dave

Thanks for that one. Really helpful. I need to send you a patch to get a little more data. I don't know when I will be able to do it though.
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

