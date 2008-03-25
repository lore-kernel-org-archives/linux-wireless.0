Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbYCYRVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 13:21:52 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: mac80211 - 10.0.4 - Kernel - 2.6.23.9-1mdv
Date: Tue, 25 Mar 2008 10:10:22 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004037184@orsmsx416.amr.corp.intel.com> (sfid-20080325_172157_627537_9B999A9F)
In-Reply-To: <aed435370803211515n5223a7aaob31339ed427a02cd@mail.gmail.com>
References: <aed435370803211515n5223a7aaob31339ed427a02cd@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Rakesh Sinha" <rakesh.usenet@gmail.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, March 21, 2008 3:16 PM, Rakesh Sinha wrote:

> Hi -
>  I am trying to build the mac80211 system on my Mandirva 2008
> package. Kernel - 
> 
> # uname -a
> Linux localhost 2.6.23.9-1mdv #1 Tue Nov 27 03:30:42 EST 2007 i686
> Genuine Intel(R) CPU           T2060  @ 1.60GHz GNU/Linux
> 
> I am looking at the instructions available here -
> 
> http://intellinuxwireless.org/?p=mac80211&n=HOWTO-mac80211 .
> 
> After running make on 10.0.4 version of mac80211 - this is what I get
> on the console. 
> 
> ----patch failure output-----
> patching file net/mac80211/ieee80211.c
> Hunk #1 FAILED at 2817.
> Hunk #2 FAILED at 2838.
> Hunk #3 FAILED at 2890.
> Hunk #4 FAILED at 2975.
> Hunk #5 FAILED at 2990.
> Hunk #6 FAILED at 3003.
> Hunk #7 FAILED at 3019.
> 7 out of 7 hunks FAILED -- saving rejects to file
> net/mac80211/ieee80211.c.rej
> 
> pending/0033-mac80211-fix-a-msdu-header.patch failed. Terminating.
> If patch or script failed, check pre/ and post/ for current stage.
> make: *** [modified] Error 1 
> 

Looks like the line endings in that patch may be wrong. Please run the
following:
$ make clean
$ dos2unix pending/0033-mac80211-fix-a-msdu-header.patch

Now try to build the mac80211 again.

Reinette

