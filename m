Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932594Ab2ASSaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 13:30:02 -0500
Date: Thu, 19 Jan 2012 13:29:56 -0500
From: Dave Jones <davej@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Dan Williams <dcbw@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi worse than ever in current git.
Message-ID: <20120119182955.GA1630@redhat.com> (sfid-20120119_193045_841472_7C2A7C12)
References: <20120110184917.GA26973@redhat.com>
 <1326221614.5067.6.camel@dcbw.foobar.com>
 <0BA3FCBA62E2DC44AF3030971E174FB3063085@HASMSX103.ger.corp.intel.com>
 <20120111014243.GA22066@redhat.com>
 <0BA3FCBA62E2DC44AF3030971E174FB306429E@HASMSX103.ger.corp.intel.com>
 <20120111195055.GA5140@redhat.com>
 <0BA3FCBA62E2DC44AF3030971E174FB3064AF5@HASMSX103.ger.corp.intel.com>
 <CANUX_P3UHz-Pr_M1H5pAbmKDY70es7nxkWSDGXG6-hvrPAMCJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P3UHz-Pr_M1H5pAbmKDY70es7nxkWSDGXG6-hvrPAMCJw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 19, 2012 at 08:47:28AM +0200, Emmanuel Grumbach wrote:
 > Ok, I finally had a change to take a closer look at this. Please run
 > with debug=0xC0000000.
 > 
 > This will be noisy, but I guess we have no choice...
 > I will be travelling next week, so...

Ah. Got it. I had to do a large download (a kernel tarball was enough) to trigger it.
Log is at http://davej.fedorapeople.org/iwl-debug.txt

The download began at around 13:17 in the log.
It hung shortly afterwards.

	Dave

