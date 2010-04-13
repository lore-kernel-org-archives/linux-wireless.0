Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33951 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab0DMVox (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 17:44:53 -0400
Subject: Re: Problem: Regression with iwl 4965 since 2.6.32.10
From: reinette chatre <reinette.chatre@intel.com>
To: U Kuehn <ukuehn@acm.org>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4BC04027.1090802@acm.org>
References: <4BC04027.1090802@acm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 14:44:52 -0700
Message-ID: <1271195092.14052.8010.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-04-10 at 02:08 -0700, U Kuehn wrote:
> Hi,
> 
> since 2.6.32.10 I am experiencing problems with my iwl4965 card. The
> system is a Thinkpad X61s under debian unstable with self-compiled kernel.
> 
> In my usual setup, I connect to an WPA2-configured access point using
> wpa_supplicant. Starting with 2.6.32.10 networking stops to work shortly
> after the 4-way handshake. After the next re-keying it works again for a
> short time.
> 
> I tracked the problem down to commit
> 44af042e42f2231579ea8ef7586d3789d198f609.
> 

Two more patches following up on the one you mention are on their way to
stable. If you want to pick them up earlier they are:
iwlwifi: counting number of tfds can be free for 4965
iwlwifi: need check for valid qos packet before free

In fact ... I just checked and they are both already queued for 2.6.32
so you can just pick them up from the 2.6.32 stable queue
( http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=tree;f=queue-2.6.32;hb=HEAD )

... in fact ... I suggest you take all the iwlwifi patches there.

Sorry for the inconvenience

Reinette


