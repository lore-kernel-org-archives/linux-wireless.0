Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:26662 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbYAYVqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 16:46:44 -0500
Received: by fg-out-1718.google.com with SMTP id e21so785933fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2008 13:46:42 -0800 (PST)
Message-ID: <247d6d340801251346k28868f4fh3d46f4bb66d4dfb5@mail.gmail.com> (sfid-20080125_214649_578756_A7861CA7)
Date: Fri, 25 Jan 2008 23:46:42 +0200
From: "Guy Cohen" <guy.cohen@intel.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: Linux 2.6.24-rc7
Cc: "Inaky Perez-Gonzalez" <inaky@linux.intel.com>,
	"Linus Torvalds" <torvalds@linux-foundation.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200801252221.07558.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	 <200801251941.25310.mb@bu3sch.de>
	 <200801251311.45392.inaky@linux.intel.com>
	 <200801252221.07558.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/25/08, Michael Buesch <mb@bu3sch.de> wrote:
> On Friday 25 January 2008 22:11:44 Inaky Perez-Gonzalez wrote:
> > Well, you forgot the point that maybe it is not that simple to get such
> > a seemingly simple change into the firmware for a long list of reasons.
>
> The reasons being?

Please stop being a smug. We are not going to expose here 4965's HW or
FW architecture. [did you think about the theoretical possibility that
240Mbps HW may handle its RX data path not purely by FW SW?].
Currently we don't have any magic solution for that.

The right solution here is as Linus suggested. Align the data for CPUs
that can't handle unaligned access _only_.

Guy.

>
> --
> Greetings Michael.
