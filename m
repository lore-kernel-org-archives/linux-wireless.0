Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbXEDMin (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2007 08:38:43 -0400
Message-ID: <463B28F1.4020107@redhat.com>
Date: Fri, 04 May 2007 14:37:05 +0200
From: Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
To: Matteo Croce <rootkit85@yahoo.it>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: airo works badly
References: <200705041410.02269.rootkit85@yahoo.it>
In-Reply-To: <200705041410.02269.rootkit85@yahoo.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(CCing linux-wireless, other people might have ideas)

Matteo Croce skrev:
> Every day i gets offline after reading this in the syslog:
> 
> May  3 15:25:30 raver kernel: airo(): Probing for PCI adapters
> May  3 15:25:30 raver kernel: airo(eth0): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
> May  3 15:25:30 raver kernel: airo(eth0): Doing fast bap_reads
> May  3 15:25:30 raver kernel: airo(eth0): WPA is supported.
> May  3 15:25:30 raver kernel: airo(eth0): MAC enabled 0:d:29:4f:c:be
> May  3 15:25:30 raver kernel: airo(): Finished probing for PCI adapters
> May  3 17:59:36 raver kernel: airo(eth0): Bad size 8192
> May  3 18:47:52 raver kernel: airo(eth0): Bad size 8192
> May  3 19:05:47 raver kernel: airo(eth0): Bad size 8192
> May  3 19:08:08 raver kernel: airo(eth0): Bad size 8192
> May  3 19:20:07 raver kernel: airo(eth0): airo: BAP setup error too many retries
> May  3 19:20:07 raver kernel: airo(eth0): airo: BAP setup error too many retries
> May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> May  3 19:20:09 raver kernel: airo(eth0): airo: BAP setup error too many retries
> May  3 19:20:10 raver kernel: airo(eth0): airo: BAP setup error too many retries
> May  3 19:20:10 raver kernel: airo(eth0): airo: BAP setup error too many retries

Hi,

What kernel version are you using? Is this a regression? If so, what was
the last version that worked well?
What if you rmmod the driver and then reload it? Does it make it work again?
What hardware is it exactly? The airo driver supports more than one type
of card.
Are you doing anything special with the card, like running some wifi
monitoring application for instance?

Michal
