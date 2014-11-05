Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58974 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932299AbaKEQEh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 11:04:37 -0500
From: Avinash Patil <patila@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 5 Nov 2014 07:58:23 -0800
Subject: RE: [PATCH] mwifiex: module load parameter for interface creation
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC666FA7DC29@SC-VEXCH2.marvell.com> (sfid-20141105_170442_781101_01C46D09)
References: <1415196491-25391-1-git-send-email-patila@marvell.com>
	 (sfid-20141105_093859_779701_4AEAB3EA),<1415195100.7485.1.camel@sipsolutions.net>
In-Reply-To: <1415195100.7485.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Customer does not wish to add interface manually using iw or other tools. So we have provided option to load driver with module parameters to meet this requirement.
For all other cases, where default driver_mode is 0x1 behavior remains unchanged.

Thanks,
Avinash
________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Wednesday, November 05, 2014 7:15 PM
To: Avinash Patil
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; Cathy Luo; Marc Yang; Amitkumar Karwar
Subject: Re: [PATCH] mwifiex: module load parameter for interface creation

On Wed, 2014-11-05 at 19:38 +0530, Avinash Patil wrote:
> This patch adds module load parameter driver_mode for mwifiex
> which would enable driver to create AP or P2P client interface while loading
> module. driver_mode is bitmap of interface modes for station, AP and
> P2P client.
>
> Station interface is created by default and is unaffected by driver_mode
> parameter.

Not really sure why this would make sense or be needed, you can always
create the interfaces from userspace?

johannes

