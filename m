Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP02.calltower.com ([69.4.184.249]:3828 "EHLO
	L01SLCSMTP02.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400AbZHFOqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 10:46:45 -0400
Subject: Re: CRDA and cross-compilation
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4A7A8F7E.6020503@redfish-solutions.com>
References: <4A7A8F7E.6020503@redfish-solutions.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 09:46:33 -0500
Message-Id: <1249569993.6446.2.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-06 at 01:08 -0700, Philip A. Prindeville wrote:
> Who currently owns CRDA?
> 
> I started to stare at cross-compiling issues, but realized that we need
> two versions of reglib.o and print-regdom.o...
> 
> One to link with regdumpdb (compiled with HOSTCC) and one to link with
> everything else (compiled with TARGET_CC)...
> 
> No easy way to do this without a lot of changes.

I posted a 5-part patch series to address this issue.
To the best of my knowledge, it has not been applied yet.

You can find it here:

http://article.gmane.org/gmane.linux.kernel.wireless.general/35350

HTH,
jdl


