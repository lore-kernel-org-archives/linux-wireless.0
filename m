Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47800 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab0CWNpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 09:45:15 -0400
Date: Tue, 23 Mar 2010 09:20:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano (Nokia-D/Helsinki)" <Luciano.Coelho@nokia.com>
Subject: Re: [PATCH 2/2] mac80211: Add support for connection quality
	monitoring
Message-ID: <20100323132045.GB30785@tuxdriver.com>
References: <1269327754-995-1-git-send-email-juuso.oikarinen@nokia.com> <1269327754-995-3-git-send-email-juuso.oikarinen@nokia.com> <1269328436.11714.56.camel@localhost.localdomain> <1269329862.10120.768.camel@wimaxnb.nmp.nokia.com> <1269346493.11714.64.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1269346493.11714.64.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 23, 2010 at 05:14:53AM -0700, Marcel Holtmann wrote:
> Hi Juuso,
> 
> > > > Add support for the set_cqm_config op. This op function configures the
> > > > requested connection quality monitor rssi threshold and rssi hysteresis
> > > > values to the hardware  if the hardware supports
> > > > IEEE80211_HW_SUPPORTS_CQM.
> > > > 
> > > > For unsupporting hardware, currently -EOPNOTSUPP is returned, so the mac80211
> > > > is currently not doing connection quality monitoring on the host. This could be
> > > > added later, if needed.
> > > 
> > > I think you mean "For unsupported hardware, ..." ;)
> > 
> > I guess you could phrase it like this as well. Do you think this is a
> > problem, i.e. do you want me to resubmit a fixed patch?
> 
> you can leave this up to John actually. He could also fix this on the
> fly when it applies the patch. However if he wants you to re-submit you
> might have to do it ;)

I'll take care of it -- this is what I live to do. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
