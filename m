Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:37938 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbYDRWX7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 18:23:59 -0400
Received: from peterson.fenrir.org.uk ([10.0.0.2])
	(TLSv1:AES256-SHA:256)
	by mx.fenrir.org.uk with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1Jmyzu-0007oX-6V
	for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2008 23:23:58 +0100
Date: Fri, 18 Apr 2008 23:23:58 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
To: linux-wireless@vger.kernel.org
Subject: Re:  RE: iwl3945 problem with 2.6.25-rc9
Message-ID: <20080418232358.000fbdf7@peterson.fenrir.org.uk> (sfid-20080418_232413_255865_9BD07164)
In-Reply-To: <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	<fu5iel$c45$1@ger.gmane.org>
	<fu5l5r$pm8$1@ger.gmane.org>
	<1208376292.27708.3.camel@localhost.localdomain>
	<D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
	<D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
	<fu931e$k1b$1@ger.gmane.org>
	<D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	<1208555842.4848.56.camel@johannes.berg>
	<D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 18 Apr 2008 15:12:13 -0700
"Chatre, Reinette" <reinette.chatre@intel.com> wrote:

> Explicitly enabling sw scanning is an interesting idea. 
> 
> Marcus: could you please run your test twice with that patch? The first
> time you run it as you did before, the second time please provide the
> driver parameter "disable_hw_scan=1" together with the debug parameter.

Not wishing to muddy the waters, but I've found that the iwlwifi driver
with a 3945 card is only reliable for scanning and associating for
my laptop (x86_64) with disable_hw_scan=1 set, this is with
2.4.24.4-64.fc8 kernel. Driver version is 1.2.26.

Previous to the recent heavy driver development, with 2.6.23.15-137.fc8
the opposite was the case. This was driver version 1.2.23.

Currently with sw scanning *every* scan returns my own 2 APs, whereas
using hw scanning I often receive "No scan results" and my 2 APs
sometimes appear in the scan output and disappear frequently. It's
equally unreliable when I can see my neighbours APs, the software scan
is reliable when signals are strong enough to register at all.

One of the Fedora common bugs advised the used of sw scanning, this is
still showing up on the common bugs list.

-- 

Brian Morrison

   "Arguing with an engineer is like wrestling with a pig in the mud;
    after a while you realize you are muddy and the pig is enjoying it."
