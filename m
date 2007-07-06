Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.229]:50425 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760859AbXGFPlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 11:41:02 -0400
Received: by wr-out-0506.google.com with SMTP id i30so201615wra
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2007 08:40:59 -0700 (PDT)
Message-ID: <445f43ac0707060840k34d9554cta9ff11cad314db76@mail.gmail.com>
Date: Fri, 6 Jul 2007 08:40:58 -0700
From: "Javier Cardona" <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: libertas (private) ioctls vs. nl80211
Cc: linux-wireless@vger.kernel.org, dcbw@redhat.com, marcelo@kvack.org
In-Reply-To: <20070614190936.GA28917@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <1181757483.29767.99.camel@johannes.berg>
	 <20070614170901.GA13384@infradead.org>
	 <20070614103836.23b07a72.akpm@linux-foundation.org>
	 <20070614181307.GA16856@infradead.org>
	 <alpine.LFD.0.98.0706141121080.14121@woody.linux-foundation.org>
	 <20070614190936.GA28917@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

On 6/14/07, John W. Linville <linville@tuxdriver.com> wrote:
> I'm not aware of any project working on wireless mesh in mac80211 at
> the moment, serious or otherwise.  I think one would be worthwhile,
> but I don't know of anyone working on it.

We (cozybit Inc.) are working on an open implementation of 802.11s for
Linux, based on mac80211.  We implemented an early draft
implementation of 802.11s for the Marvell wireless interface used on
the One Laptop Per Child.  That implementation was done entirely in
firmware to take advantage of the unique capabilities of Marvell's
wireless device:  the system-on-chip wireless module enables the
laptop to act as a low-power, fully functional mesh point even when
the main CPU is off.

Our next goal is to do a reference implementation of the latest
802.11s draft on Linux.  The hope is that it will help to achieve
early interoperability and convergence of the standard.  We are
seeking sponsors for the project.  So far Nortel has expressed strong
interest.

More details will follow soon.

Javier
