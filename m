Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:22471 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759718AbXJOM3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 08:29:36 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: move to uniform lbs_/LBS_ namespace
Date: Mon, 15 Oct 2007 14:26:39 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
References: <200710111151.06989.hs4233@mail.mn-solutions.de> <200710151307.01976.hs4233@mail.mn-solutions.de> <1192447279.3349.29.camel@johannes.berg>
In-Reply-To: <1192447279.3349.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710151426.39469.hs4233@mail.mn-solutions.de> (sfid-20071015_132941_286340_1C033561)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Send a link I guess.

Okay, have done this. Please keep in mind that my git-fu is quite 
undeveloped (especially the branching thingy).

However, I created on git.infradead.org a git with linux-2.6 as 
reference. Into this I pulled wireless-2.6. Then I checked this 
out on my local computer, switched to branch everything and 
applied my current 4 patches that aren't yet in wireless-2.6. 
This again I pushed.

I hope I did everything right :-)

http://git.infradead.org/?p=users/schurig/libertas-cleanup.git;a=shortlog;h=cleanup
