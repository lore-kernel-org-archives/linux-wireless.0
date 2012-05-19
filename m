Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1207 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964818Ab2ESIt0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 04:49:26 -0400
Message-ID: <4FB75E88.3010908@broadcom.com> (sfid-20120519_104944_354034_98CB2F76)
Date: Sat, 19 May 2012 10:49:12 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jonathan Nieder" <jrnieder@gmail.com>
cc: "Greg KH" <greg@kroah.com>, stable@vger.kernel.org,
	"Touko Korpela" <touko.korpela@iki.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Stanislaw Gruszka" <sgruszka@redhat.com>
Subject: Re: [PATCH 3.2.y, 3.3.y] brcm80211: smac: fix endless retry of
 A-MPDU transmissions
References: <1330018703-2472-1-git-send-email-arend@broadcom.com>
 <1330018703-2472-2-git-send-email-arend@broadcom.com>
 <20120516222824.GA11009@burratino> <20120518195812.GE4874@kroah.com>
 <20120518205118.GE2986@burratino>
In-Reply-To: <20120518205118.GE2986@burratino>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/18/2012 10:51 PM, Jonathan Nieder wrote:
> Hi Greg,
> 
> Greg KH wrote:
>> On Wed, May 16, 2012 at 05:28:25PM -0500, Jonathan Nieder wrote:
> 
>>> commit 5e379203c7788b7af01150bfadbc74d2797a2ef4 upstream.
> [...]
>> It doesn't apply to the 3.3-stable tree, so it's a bit hard for me to
>> apply it...
> 
> My bad --- looks like it was already applied during the 3.3 cycle as
> v3.3~19^2^2~7 (commit 85091fc0a756).  Sorry I missed that before.
> 
> Thanks,
> Jonathan
> 

Yes. The patch was posted upstream with Cc to stable. As it did not
apply to earlier kernels it was marked for 3.3 stable only. Jonathan
ported the original patch for the earlier kernels.

Gr. AvS

