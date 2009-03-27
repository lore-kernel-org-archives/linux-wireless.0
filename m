Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57005 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837AbZC0PNm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:13:42 -0400
Date: Fri, 27 Mar 2009 12:13:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill-input: remove unused code
Message-ID: <20090327151337.GD24288@khazad-dum.debian.net> (sfid-20090327_161344_071612_89B43F9A)
References: <1238159804.4452.4.camel@johannes.local> <20090327143608.GB24288@khazad-dum.debian.net> <200903271559.02276.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200903271559.02276.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Mar 2009, Michael Buesch wrote:
> So in my opinion it's _not_ a good idea to lookup some old code for implementing
> a feature. Instead one should think about it and understand the stuff and then implement it.
> And if there are pitfalls that are not obvious after one completely read the code, one
> should consider a redesign.

Or better comments in the code, because right now there are no comments
since the code was quite easy to read and understand, and it was
feature-complete (even if part of it was commented out due to lack of
users).

Well, I certainly don't fell too strongly about it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
