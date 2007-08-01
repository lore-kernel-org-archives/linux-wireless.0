Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:41377 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbXHAJV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 05:21:58 -0400
Date: Wed, 1 Aug 2007 11:21:59 +0200
From: Edward Ando <edwardando@fastwebnet.it>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Removing the prism54 module
Message-ID: <20070801112159.47dc9689@ed.anywhere>
In-Reply-To: <43e72e890707311820h59eebf6raf5b77058e2d23dc@mail.gmail.com>
References: <20070728224008.782a3be6@ed.anywhere>
 <43e72e890707311820h59eebf6raf5b77058e2d23dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With pleasure:

lsmod
Module                  Size  Used by
tun                     7680  1 
snd_seq_oss            26816  0 
snd_seq_device          5288  1 snd_seq_oss
snd_seq_midi_event      5408  1 snd_seq_oss
snd_seq                39856  4 snd_seq_oss,snd_seq_midi_event
snd_pcm_oss            37344  0 
snd_mixer_oss          13504  1 snd_pcm_oss
pcmcia                 33184  0 
snd_intel8x0           27108  2 
snd_ac97_codec         88836  1 snd_intel8x0
ac97_bus                1824  1 snd_ac97_codec
snd_pcm                62896  3 snd_pcm_oss,snd_intel8x0,snd_ac97_codec
snd_timer              17064  2 snd_seq,snd_pcm
prism54                48848  0 
snd_page_alloc          7080  2 snd_intel8x0,snd_pcm
yenta_socket           22140  1 
rsrc_nonstatic          8580  1 yenta_socket


Edward

On Tue, 31 Jul 2007 21:20:57 -0400
"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> On 7/28/07, Edward Ando <edwardando@fastwebnet.it> wrote:
> > Dear All,
> > I am trying to set up software suspend 2 (TuxOnIce now it seems).
> > This has decided it wants to remove the prism54 module before
> > starting the hibernate process.
> >
> > When it tries to do this, (or when I manually do: "ifconfig eth1
> > down"), I start getting these messages on all terminals, ad
> > infinitum:
> >
> > kernel: unregister_netdevice: waiting for eth1 to become free. Usage
> > count = 4
> 
> Hmm... can you show lsmod output please?
> 
>   Luis
