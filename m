Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:39141 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbYJKJzw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 05:55:52 -0400
Date: Sat, 11 Oct 2008 11:55:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: Elias Oltmanns <eo@nebensachen.de>,
	Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register
 access?
In-Reply-To: <20081010213207.GA7852@infradead.org>
Message-ID: <alpine.LFD.2.00.0810111155250.3356@apollo> (sfid-20081011_115602_519887_EA777A86)
References: <alpine.LFD.2.00.0810072042140.3166@apollo> <87hc7ot804.fsf@denkblock.local> <87myhfnwne.fsf@denkblock.local> <alpine.LFD.2.00.0810082203360.3237@apollo> <alpine.LFD.2.00.0810091313380.3237@apollo> <87k5cgg87j.fsf@denkblock.local>
 <alpine.LFD.2.00.0810101127560.3271@apollo> <87abdck6sn.fsf@denkblock.local> <alpine.LFD.2.00.0810101432540.3271@apollo> <87y70wli6n.fsf@denkblock.local> <20081010213207.GA7852@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 10 Oct 2008, Christoph Hellwig wrote:

> On Fri, Oct 10, 2008 at 02:59:28PM +0200, Elias Oltmanns wrote:
> > That was my first thought when I discovered this. However, from what I
> > read on the web, I somehow got the impression that [um]delay() was
> > alright as opposed to msleep(). What exactly is the difference then?
> 
> Yes, only msleep() sleeps, mdelay spins.

Opps, right. 
