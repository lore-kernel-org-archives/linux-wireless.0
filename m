Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55687 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbYJaQPm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 12:15:42 -0400
Subject: Re: Guidelines regarding separate directory
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Roskin <proski@gnu.org>, Dave <kilroyd@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <1225447269.3535.4.camel@johannes.berg>
References: <4909EA78.3060700@lwfinger.net>
	 (sfid-20081030_181107_189082_5740895D) <1225387309.3690.73.camel@johannes.berg>
	 <490A17F3.5050802@gmail.com> <1225399481.7931.5.camel@dv>
	 <1225399682.3690.82.camel@johannes.berg>
	 <20081030231054.ehd21qipcow4kg88-cebfxv@webmail.spamcop.net>
	 <1225447269.3535.4.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 12:13:28 -0400
Message-Id: <1225469608.27440.11.camel@localhost.localdomain> (sfid-20081031_171548_934692_369D5E31)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-10-31 at 11:01 +0100, Johannes Berg wrote:
> On Thu, 2008-10-30 at 23:10 -0400, Pavel Roskin wrote:
> > Quoting Johannes Berg <johannes@sipsolutions.net>:
> 
> > The WPA support in orinoco is limited to Agere firmware.  Maybe Symbol  
> > firmware will be supported at some point.  But adding WPA support for  
> > Intersil firmware would duplicate efforts.
> 
> Yes, I know, but wouldn't adding that based on the hostap stuff be
> fairly simple? I know nobody has time to...
> 
> > The only thing I would like to change in hostap is that it should  
> > default to managed mode, like other drivers do.
> 
> No, that's not true, just see
> http://bugzilla.kernel.org/show_bug.cgi?id=11802 for example. The AP
> part also duplicates a lot of mac80211 functionality.

Orinoco is a mostly-fullmac driver, while hostap is quasi-softmac,
right?

Dan


