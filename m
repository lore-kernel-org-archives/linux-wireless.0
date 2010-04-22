Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50917 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab0DVQmS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 12:42:18 -0400
Subject: Re: [PATCH] compat: fix uevent_suppress on 2.6.29 or older kernels
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <g2o43e72e891004220933i5faec995qae1b358ce66ed2d@mail.gmail.com>
References: <1271944442-9214-1-git-send-email-notasas@gmail.com>
	 <g2o43e72e891004220933i5faec995qae1b358ce66ed2d@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 Apr 2010 12:42:17 -0400
Message-Id: <1271954537.8469.15.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-22 at 09:33 -0700, Luis R. Rodriguez wrote:

> How was this compiling for older kernels before then?

Compiling was fine, but loading the firmware was failing sometimes.  I'm
glad somebody figured it out.  Thank you, Grazvydas!

I would prefer to have replacement functions in compat-2.6.30.h rather
than ifdefs in the code.  We might want to resync compat_firmware with
the kernel one day, and ifdefs would stand in the way.

-- 
Regards,
Pavel Roskin
