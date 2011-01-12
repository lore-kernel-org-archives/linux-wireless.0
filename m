Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4753 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969Ab1ALJ0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 04:26:20 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Jon Masters" <jcm@redhat.com>,
	"Brett Rudley" <brudley@broadcom.com>
cc: devel <devel@linuxdriverproject.org>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 12 Jan 2011 01:26:16 -0800
Subject: RE: PROBLEM: brcm80211 unable to survive suspend/resume cycle
Message-ID: <400C43189542CE41BC0A5B252FC90136952FC34AE7@SJEXCHCCR02.corp.ad.broadcom.com>
References: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
 <7A94256FD72B884D9E7C55586C3CBCEE13840C62AA@SJEXCHCCR01.corp.ad.broadcom.com>
 <1289880279.3916.889.camel@constitution.bos.jonmasters.org>
 <1293028287.6319.171.camel@constitution.bos.jonmasters.org>
In-Reply-To: <1293028287.6319.171.camel@constitution.bos.jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jon,

Brett delegated this problem to me and I have resolved it in the driver. I will post it to the staging-2.6 repository in coming days when stomach flu subsides. Keep your eyes on the devel archives.

Gr. AvS

|-----Original Message-----
|From: devel-bounces@linuxdriverproject.org [mailto:devel-
|bounces@linuxdriverproject.org] On Behalf Of Jon Masters
|Sent: Wednesday, December 22, 2010 3:31 PM
|To: Brett Rudley
|Cc: devel; Linux Kernel Mailing List
|Subject: RE: PROBLEM: brcm80211 unable to survive suspend/resume cycle
|
|On Mon, 2010-11-15 at 23:04 -0500, Jon Masters wrote:
|> On Tue, 2010-11-09 at 10:02 -0800, Brett Rudley wrote:
|> > Hey Jon, thanks for the heads up.  I can repro and am looking into
|it.
|>
|> Did you get chance to poke much yet?
|
|Any word on this?
|
|Jon.
|
|
|_______________________________________________
|devel mailing list
|devel@linuxdriverproject.org
|http://driverdev.linuxdriverproject.org/mailman/listinfo/devel


