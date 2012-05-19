Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41982 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2ESQxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 12:53:24 -0400
Date: Sat, 19 May 2012 11:53:16 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Greg KH <greg@kroah.com>, stable@vger.kernel.org,
	Touko Korpela <touko.korpela@iki.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 3.2.y, 3.3.y] brcm80211: smac: fix endless retry of
 A-MPDU transmissions
Message-ID: <20120519165316.GC26095@burratino> (sfid-20120519_185329_827217_0A0629EE)
References: <1330018703-2472-1-git-send-email-arend@broadcom.com>
 <1330018703-2472-2-git-send-email-arend@broadcom.com>
 <20120516222824.GA11009@burratino>
 <20120518195812.GE4874@kroah.com>
 <20120518205118.GE2986@burratino>
 <4FB75E88.3010908@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB75E88.3010908@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel wrote:
> On 05/18/2012 10:51 PM, Jonathan Nieder wrote:

>> My bad --- looks like it was already applied during the 3.3 cycle as
>> v3.3~19^2^2~7 (commit 85091fc0a756).  Sorry I missed that before.
[...]
> Yes. The patch was posted upstream with Cc to stable. As it did not
> apply to earlier kernels it was marked for 3.3 stable only.

Technically it wasn't cc-ed to stable; it went to wireless-next
for 3.4 and then was fast-tracked through the plain wireless tree
for 3.3[1].  But the effect is basically the same.

Thanks for writing it.

Jonathan

[1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/85902
http://thread.gmane.org/gmane.linux.kernel.wireless.general/85249
