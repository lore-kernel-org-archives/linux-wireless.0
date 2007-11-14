Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:46433 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbXKNI7G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 03:59:06 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1IsE5F-0002rG-Sh
	for linux-wireless@vger.kernel.org; Wed, 14 Nov 2007 08:58:53 +0000
Received: from 80.169.182.16 ([80.169.182.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2007 08:58:53 +0000
Received: from marcus by 80.169.182.16 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2007 08:58:53 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: Re: rt2x00/rt2500 PCI unresponsive / sluggish response
Date: Wed, 14 Nov 2007 09:58:44 +0100
Message-ID: <fhedc4$5l9$1@ger.gmane.org> (sfid-20071114_085909_994963_3012F105)
References: <20071111102315.GC10486@paradigm.rfc822.org> <8e6f94720711121459j56f640abid03cb2a1eca319c2@mail.gmail.com> <20071113192330.GA19601@paradigm.rfc822.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Florian Lohoff wrote:
> You are right - its caused by a VERY low bitrate:

Looks similar to the problem I have:

http://permalink.gmane.org/gmane.linux.kernel.wireless.general/6830
http://bugzilla.kernel.org/show_bug.cgi?id=9273

Marcus


