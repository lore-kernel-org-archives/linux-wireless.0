Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:1944 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbZDHPWg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 11:22:36 -0400
MIME-Version: 1.0
In-Reply-To: <20090331122348.GA31324@hash.localnet>
References: <20090107152208.GB4207@linux.vnet.ibm.com>
	 <25891f3e0902012357n21e7bc2fmc59fb2a842631651@mail.gmail.com>
	 <20090215134702.GA10180@hash.localnet> <49A9C3D7.8060706@gmail.com>
	 <20090330085952.GB3837@linux.vnet.ibm.com>
	 <b6c5339f0903300958m587cde69o44ae24d0609228ba@mail.gmail.com>
	 <20090330175951.GB4199@linux.vnet.ibm.com>
	 <b6c5339f0903301113y6cb0b8bu1eaa55439eb18d97@mail.gmail.com>
	 <20090331035140.GC4199@linux.vnet.ibm.com>
	 <20090331122348.GA31324@hash.localnet>
Date: Wed, 8 Apr 2009 11:22:34 -0400
Message-ID: <b6c5339f0904080822m6129073ahc5caa14c3cd20fd2@mail.gmail.com> (sfid-20090408_172240_744029_50595247)
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
From: Bob Copeland <me@bobcopeland.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Dhaval Giani <dhaval.lists@thegianis.in>,
	Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	linux-kernel@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 31, 2009 at 8:23 AM, Bob Copeland <me@bobcopeland.com> wrot=
e:
> Ok - that is a useful data point. =A0Perhaps something to do with the=
 rates
> the peer supports; it would help if you could grab a scan next time y=
ou
> are in the area. =A0Turn off auto-connect to open networks, then do:

Hi Dhaval,

Would you mind trying this patch and report the warnings it triggers?

http://marc.info/?l=3Dlinux-kernel&m=3D123915183521347&q=3Draw

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
