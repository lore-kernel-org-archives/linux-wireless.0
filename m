Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:56950 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZHCWd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 18:33:27 -0400
Received: by ewy10 with SMTP id 10so3422942ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 15:33:27 -0700 (PDT)
Subject: Re: [PATCH 000/002] Fix frequent reconnects caused by new
 conection monitor
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1249056817.20593.1.camel@maxim-laptop>
References: <1249056817.20593.1.camel@maxim-laptop>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 01:33:17 +0300
Message-Id: <1249338797.13895.0.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-31 at 19:13 +0300, Maxim Levitsky wrote:
> Hi, here is the updated version of these two patches that fix the
> $SUBJECT issue.
> 
> I attach these (in case mailer mangles them), and reply with patches.
> 
> Tested both with low quality signal, and beacon loss.
> Lack of TX is found, every 30 seconds now, and quite reliable.
> Lack of beacons, triggers probe like it did every 2 seconds.
> 
> 
> 
> Best regards,
> Maxim Levitsky

Just a question, when to see these in wireless-testing?

Best regards,
	Maxim Levitsky

