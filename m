Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:49593 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1JSGqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 02:46:33 -0400
Date: Wed, 19 Oct 2011 15:46:28 +0900
From: Norbert Preining <preining@logic.at>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: David Rientjes <rientjes@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111019064628.GA14817@gamma.logic.tuwien.ac.at> (sfid-20111019_084648_441260_E754A9CC)
References: <20111019060108.GA11588@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com> <20111019062517.GC11588@gamma.logic.tuwien.ac.at> <1319003304.31823.46.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1319003304.31823.46.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Di, 18 Okt 2011, Guy, Wey-Yi wrote:
> it is very interesting, for sure there is a bug here which cause NIC
> stop working, if you look at the tx queue, hwq 0 is stop, which mean
> nothing go out. I am not sure how we get into this? yes, most likely

Yes, that is my obervation, too. Nothing goes out, so reassociation
does not succeed.

> Could you help me how to repro this problem?

Not really, besides you come here to my university ;-)
I have this problem currently only with the routers here at
the university, not with other routers.

Any other way I can provide you help?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SKENFRITH (n.)
The flakes of athlete's foot found inside socks.
			--- Douglas Adams, The Meaning of Liff
