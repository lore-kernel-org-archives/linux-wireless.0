Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab1F3JxG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 05:53:06 -0400
Date: Thu, 30 Jun 2011 11:51:38 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Erik Hardesty <ehardesty@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlagn: Problems with Intel Wifi Link 1000 on newer kernels
Message-ID: <20110630095137.GA2666@redhat.com> (sfid-20110630_115311_441300_AF317105)
References: <BANLkTim83iarV-J08JAsVtfLR2ziqLs=iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTim83iarV-J08JAsVtfLR2ziqLs=iQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 17, 2011 at 01:14:11AM -0500, Erik Hardesty wrote:
> Having trouble with iwlagn in kernels newer than 2.6.38.
> I've tried 2.6.39 and 3.0rc3 and both give me the same problem.
> I have the latest intel firmware installed on the system. Both
> iwlwifi-1000-3.ucode
> and iwlwifi-1000-5.ucode are in /lib/firmware
> 
> Note: 2.6.38 does not exhibit the same issue and works fine.

If there is no other proposition to fix the issue from Intel,
perhaps you could bisect the problem. 

Stanislaw
