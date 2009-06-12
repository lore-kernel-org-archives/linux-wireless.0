Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slackware.com ([64.57.102.34]:48756 "EHLO bob.slackware.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbZFLGo3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 02:44:29 -0400
Date: Thu, 11 Jun 2009 22:51:24 -0700 (PDT)
From: Robby Workman <rworkman@slackware.com>
To: ilw@linux.intel.com
cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: iwlagn crash on 2.6.29.4
Message-ID: <alpine.LNX.1.10.0906112246330.23960@bob.slackware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2.6.29.4, I just got a crash in iwlagn under heavy network
throughput.  I was transferring a dvd iso from one box in my
lan to another, and the following occurred:

   http://slackware.com/~rworkman/OOPS

It didn't bring the entire system to a halt (thankfully);
removing and reloading the iwlagn module made everything
just fine. :-)

If any more information is needed, let me know.  I'm more than
willing to test patches and such...

-RW
