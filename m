Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:23878 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYA0C0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 21:26:47 -0500
Received: by py-out-1112.google.com with SMTP id u52so1776760pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2008 18:26:45 -0800 (PST)
Message-ID: <43e72e890801261826vc29b5e1kda2bd8c734df7693@mail.gmail.com> (sfid-20080127_022657_374109_407D0FE9)
Date: Sat, 26 Jan 2008 21:26:44 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: Linux 2.6.24-rc7
Cc: inaky@linux.intel.com, mb@bu3sch.de, torvalds@linux-foundation.org,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
In-Reply-To: <20080126.054223.118097210.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200801251311.45392.inaky@linux.intel.com>
	 <200801252221.07558.mb@bu3sch.de>
	 <200801251328.35985.inaky@linux.intel.com>
	 <20080126.054223.118097210.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 26, 2008 8:42 AM, David Miller <davem@davemloft.net> wrote:
> From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
> Date: Fri, 25 Jan 2008 13:28:35 -0800
>
> > For example: want to ship new firmware, drivers *and* full validation and
> > certification for a product that is already completed just to satisfy a
> > fraction of a market which is not part of the designed target?
> >
> > Do you know how much money that costs?
>
> I'm glad you guys are the only one's with access to the firmware
> source, thus enduring that you can constantly come up with reasons
> like this in order to not have to fix the problem.
>
> You know that if the source were available, the community would have
> fixed the bug ages ago.
>
> But the situation is entirely in Intel's control which is surely
> exactly the way they like it.

IMO the real problem is not Intel not wanting to free the firmware,
but that legal says they can't. The reason why legal would tell them
that is due to the attempt to comply to out-of-date regulatory laws
which currently exist in different and sometimes in most countries. At
least within the US, for example, the laws dealing with new devices
like SDRs [1] don't say you can't use FOSS but "warn that the
certification will be less likely to be granted if the manufacturer
relies 'wholly' on FOSS in building the device" [2]. IMO these laws
are just new and regulatory agencies just have  no good ideas as to
how to properly regulate these type of devices properly yet. My
current stance on this issue is to have regulatory bodies shift
liability to the user for use of unsupported software. Changing
regulatory bodies to embrace this idea will take a while so in the
meantime we have to deal with what we have and that is wireless cards
coming close to being SDRs but still being certified under part 15
rules and corporate legal teams just wanting to play it safe.

So all this is in general is not about vendors not wanting to support
us. Its simply the fear uncertainty and doubt game, but the stakes are
pretty high for vendors. In the long run my hope is we can get an
alliance of wireless vendors going to eventually make a proposal to
different legislative bodies to consider changing certification
requirements for the sake of advancing these technologies with the
community even using FOSS.

[1] http://en.wikipedia.org/wiki/Software_radio
[2] http://www.softwarefreedom.org/resources/2007/fcc-sdr-whitepaper.html

  Luis
