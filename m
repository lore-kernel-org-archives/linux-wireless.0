Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28004 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbZD1Q72 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 12:59:28 -0400
Subject: Re: iwlagn: Microcode SW error detected.  Restarting 0x82000000.
From: reinette chatre <reinette.chatre@intel.com>
To: Philipp Wagner <lists@philipp-wagner.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49F70489.5070004@philipp-wagner.com>
References: <49F70489.5070004@philipp-wagner.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 10:05:34 -0700
Message-Id: <1240938334.1207.7.camel@rc-desk> (sfid-20090428_185933_151658_25332FA0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Philipp,

On Tue, 2009-04-28 at 06:28 -0700, Philipp Wagner wrote:
> Hi,
> 
> I'm running into a
> Microcode SW error detected.  Restarting 0x82000000.
> error with the iwlagn driver.
> 
> # uname -a
> Linux 2.6.30-rc2-git6-master_20090416115717_67cb21e9-vanilla #2 SMP Thu
> Apr 23 19:24:36 CEST 2009 x86_64 x86_64 x86_64 GNU/Linux
> 
> I uploaded a (hopefully) complete log generated with the "debug=0x43fff"
> at http://philipp.wagner.name/temp/iwlagn-microcodeerror.txt
> 
> Is this a known problem? I mainly experience this problem at university
> with many access points for the same essid and it seems to happen more
> often with encrypted communication (802.1x) - but that's only a feeling,
> not a fact :)

Thank you for that great log. Could you please add it to
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1965 ?

Thank you

Reinette


