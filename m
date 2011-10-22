Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab1JVIbN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 04:31:13 -0400
Date: Sat, 22 Oct 2011 10:30:05 +0200
From: Greg KH <gregkh@suse.de>
To: Arend Van Spriel <arend@broadcom.com>
Cc: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
Message-ID: <20111022083005.GA6032@suse.de> (sfid-20111022_103128_605185_DD53281C)
References: <1319028563.8416.1.camel@edumazet-laptop>
 <20111019130749.GD11883@schottelius.org>
 <20111019142837.GA1414@schottelius.org>
 <4E9EE20F.1030403@broadcom.com>
 <20111019145501.GB1414@schottelius.org>
 <4E9EFF51.6000104@broadcom.com>
 <20111019214250.GC2432@schottelius.org>
 <4E9FBFA7.4040502@broadcom.com>
 <20111022015945.GC26186@ethz.ch>
 <400C43189542CE41BC0A5B252FC90136BC0E147BCB@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0E147BCB@SJEXCHCCR02.corp.ad.broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 22, 2011 at 01:13:34AM -0700, Arend Van Spriel wrote:
> > From: Nico Schottelius [mailto:nico-linux-20111017@schottelius.org]
> > Sent: zaterdag 22 oktober 2011 4:00
> > 
> > Hey Arend,
> > 
> > it seems that your patch really solves this problem.
> 
> Great. This fix is in linux-next tree.
> 
> Greg,
> 
> This problem causes packets to get dropped on 5GHz. Should I
> sent a patch for 3.1 (staging-linus) for this? It is already
> fixed in wireless-next.

No, just wait for it to get into Linus's tree for 3.2-rc1, and then
email the git commit id to stable@vger.kernel.org so it will be added to
the 3.1-stable releases.

greg k-h
