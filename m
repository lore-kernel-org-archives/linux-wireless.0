Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:3840 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbYHRS71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 14:59:27 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1327570yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2008 11:59:26 -0700 (PDT)
Message-ID: <445f43ac0808181159v78fe2addic9c90442da256693@mail.gmail.com> (sfid-20080818_205933_547772_084871A2)
Date: Mon, 18 Aug 2008 11:59:25 -0700
From: "Javier Cardona" <javier@cozybit.com>
To: YanBo <dreamfly281@gmail.com>
Subject: Re: About MPP & MAP open80211 implementation status
Cc: devel@lists.open80211s.org,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1197ff4c0808180146x1bb72246s3e18a14f170bb6c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1197ff4c0808112342h5fd41bf1pe565c15d0939686c@mail.gmail.com>
	 <445f43ac0808120938m73fd318eqb63ccc804743ccf7@mail.gmail.com>
	 <1197ff4c0808132008t12c7117dod11873686f3b8670@mail.gmail.com>
	 <445f43ac0808132123t62cec7e0p8ab6b5d49c0baedc@mail.gmail.com>
	 <1197ff4c0808180146x1bb72246s3e18a14f170bb6c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YanBo,

On Mon, Aug 18, 2008 at 1:46 AM, YanBo <dreamfly281@gmail.com> wrote:
>> The "three adddress problem" is caused by the use of *legacy* (e.g.
>> any unmodified off-the shelf) AP to connect a mesh portal to an
>> external network.
>> There is no problem if you use a wired ethernet connection and a
>> standard 802.3 bridge between the wired and the mesh interface, e.g
>>
>> A -- ethernet -- B --- mesh --- C
>
> In currently o11s implementation,  after bridge a wired and the mesh
> interface, it seemed o11s can't correctly deal with the packet that
> forward by 802.3 bridge. so A still can't reach C.

This is correct, yes.  What I was trying to say is that it will never
be possible to connect a mesh to an external network using a legacy
AP.  On the other hand, it will be possible to connect the mesh to an
external network via an 802.1D bridge and a wired ethernet interface.
But only when mesh portal functionality is implemented in o11s.

Cheers,

Javier
