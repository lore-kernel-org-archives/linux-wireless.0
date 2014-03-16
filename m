Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0199.hostedemail.com ([216.40.44.199]:60651 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751036AbaCPHJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2014 03:09:39 -0400
Message-ID: <1394953776.5689.8.camel@joe-AO722> (sfid-20140316_081041_801071_937E50EF)
Subject: Re: [PATCH v5 01/11] rsi: Adding RS9113 header files.
From: Joe Perches <joe@perches.com>
To: Fariya <fariyaf@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 16 Mar 2014 00:09:36 -0700
In-Reply-To: <CAG+h2qhwa-C4DC65ebV=s9tDEg-40QzS5604VBmMU3GhwkY07w@mail.gmail.com>
References: <1394921832-4056-1-git-send-email-fariyaf@gmail.com>
	 <1394921832-4056-2-git-send-email-fariyaf@gmail.com>
	 <1394922230.5689.2.camel@joe-AO722>
	 <CAG+h2qhwa-C4DC65ebV=s9tDEg-40QzS5604VBmMU3GhwkY07w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-03-16 at 10:03 +0530, Fariya wrote:
> Hello,
> 
> The prints that we have added in the driver are supposed to be informative
> and hence put up in the KERN_INFO log level.

You should categorize them better and definitely not
call the function rsi_dbg.


