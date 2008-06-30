Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from miranda.se.axis.com ([193.13.178.8]:49235 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183AbYF3L7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 07:59:20 -0400
From: "Johan Adolfsson" <Johan.Adolfsson@axis.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>,
	"'Johan Adolfsson'" <johan.adolfsson@axis.com>
Cc: <linux-wireless@vger.kernel.org>,
	"'Dan Williams'" <dcbw@redhat.com>,
	<libertas-dev@lists.infradead.org>
Subject: RE: [PATCH] Add module parameter to override regioncode on libertas
Date: Mon, 30 Jun 2008 13:58:16 +0200
Message-ID: <056e01c8daa8$94c70150$0137550a@se.axis.com> (sfid-20080630_135923_113408_EEE0F95D)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <1214823915.5507.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Johannes Berg [mailto:johannes@sipsolutions.net] 
> Sent: den 30 juni 2008 13:05
> To: Johan Adolfsson
> Cc: linux-wireless@vger.kernel.org; 'Dan Williams'
> Subject: Re: [PATCH] Add module parameter to override 
> regioncode on libertas
> 
> 
> On Mon, 2008-06-30 at 08:36 +0200, Johan Adolfsson wrote:
> > Resending to linux-wireless after positive feedback on libertas-dev.
> > 
> > Attached is a patch against the 2.6.25 driver that adds a 
> > module parameter called "regioncode" to set the region code
> > in the libertas driver.
> > 
> > Hope the format is ok.
> > Signed-off-by: Johan.Adolfsson@axis.com
> 
> I wonder if libertas could start using cfg80211 for this? 
> Just register
> a wiphy and use the enabled channels there?
> 
> johannes

I suppose it could, just read a little on the subject, but it's unclear 
to me how mature the cfg80211 is and how much overkill it is compared 
to what we really need (embedded solution, regulatory domains set at 
production time (before shipping) and not easaly selectable by end user).

(I added liberas-dev to Cc:)

/Johan

