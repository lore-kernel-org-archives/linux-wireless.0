Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:51846 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYDDOIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 10:08:10 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] rtl8187b work in progress...
Date: Fri, 4 Apr 2008 11:07:59 -0300
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
References: <pan.2008.04.01.18.07.31.772700@gimpelevich.san-francisco.ca.us> <200804012340.01354.herton@mandriva.com.br> <1207280003.2585.15.camel@dv>
In-Reply-To: <1207280003.2585.15.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804041107.59990.herton@mandriva.com.br> (sfid-20080404_150818_112696_D6974E2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Friday 04 April 2008 00:33:23 Pavel Roskin escreveu:
> On Tue, 2008-04-01 at 23:40 -0300, Herton Ronaldo Krzesinski wrote:
> > > +		return 0;
> >
> >                 ^^^
> > Now that I removed this return (obviously wrong heh) It seems to work ok
> > :), the rtl8187b I have here at least now successfuly scans for
> > aps/receive data, later I'll do more testing/improvements.
>
> Patching the latest linux-wireless with it is not fun, too many
> rejects :-(
>
> Considering that compat-wireless brings the goodness of the current
> driver to the users of all recent kernels, may I humbly suggest that
> linux-wireless is used for development?

Yes, I will later do a patch against linux-wireless, I only posted it as a 
work in progress. But before I post an updated patch I want to fix it first 
to use changes made by John (like not duplicating the functions etc.) and 
there is another fundamental problem that I must first fix: it works and 
scans for aps, but for some reason I don't get authentication from access 
point (while normal 8187 gets data with IEEE80211_STYPE_AUTH in 8187b for 
some reason don't...).

--
[]'s
Herton
