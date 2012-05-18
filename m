Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44892 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965500Ab2ERUvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 16:51:23 -0400
Date: Fri, 18 May 2012 15:51:18 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, Touko Korpela <touko.korpela@iki.fi>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 3.2.y, 3.3.y] brcm80211: smac: fix endless retry of
 A-MPDU transmissions
Message-ID: <20120518205118.GE2986@burratino> (sfid-20120518_225127_844019_350743AE)
References: <1330018703-2472-1-git-send-email-arend@broadcom.com>
 <1330018703-2472-2-git-send-email-arend@broadcom.com>
 <20120516222824.GA11009@burratino>
 <20120518195812.GE4874@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120518195812.GE4874@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

Greg KH wrote:
> On Wed, May 16, 2012 at 05:28:25PM -0500, Jonathan Nieder wrote:

>> commit 5e379203c7788b7af01150bfadbc74d2797a2ef4 upstream.
[...]
> It doesn't apply to the 3.3-stable tree, so it's a bit hard for me to
> apply it...

My bad --- looks like it was already applied during the 3.3 cycle as
v3.3~19^2^2~7 (commit 85091fc0a756).  Sorry I missed that before.

Thanks,
Jonathan
