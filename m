Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4799 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab1CSMOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 08:14:06 -0400
Subject: new utility kernel module for detecting cores in newer chipsets
References: <op.vslagcb13ri7v4@arend-laptop>
To: "Greg KH" <greg@kroah.com>
Date: Sat, 19 Mar 2011 13:13:48 +0100
cc: linuxdriverproject <devel@linuxdriverproject.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vslaxakc3ri7v4@arend-laptop>
In-Reply-To: <op.vslagcb13ri7v4@arend-laptop>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ mailing lists

Hi Greg,

There has been several discussion in the community (mainly by b43 and ssb
developers, I believe) to add support for chip core interconnect used in
newer Broadcom chips.  Our brcm80211 drivers already have this support and
we have isolated that functionality in a separate kernel module called
brcmaxi to provide it to other drivers. Currently, I have it located under
drivers/staging/brcm80211 as I am not sure whether or not its purpose
justifies a separate folder (under staging or not).

What are your thoughts about this? I would like to know before submitting
a patch for this.

Gr. AvS


-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

