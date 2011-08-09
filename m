Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46787 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab1HIJkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:40:16 -0400
Subject: Re: Making sense of cfg80211_scan_request.n_ssids
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: Daniel Drake <dsd@laptop.org>, Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1312882560.2407.139.camel@cumari>
References: <CAGq3pz40rsMudofq6Njr0_h1G=EqEigGL-NkODj8Rb6h2bMGMQ@mail.gmail.com>
	 <4E3875BE.9070504@gnu.org>
	 (sfid-20110803_001012_532868_0AAF0D7E)  <1312792639.4372.7.camel@jlt3.sipsolutions.net>
	 <1312882560.2407.139.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 11:40:09 +0200
Message-ID: <1312882809.4109.4.camel@jlt3.sipsolutions.net> (sfid-20110809_114024_797655_282A91A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:36 +0300, Luciano Coelho wrote:

> > Yeah. "iw dev eth0 scan passive" will cause n_ssids to be 0.
> 
> I think the question was slightly different.  As I understand, Daniel
> wants to know why the n_ssids is 1 even if no SSID is passed from user
> space.

Well, actually, in the iw scan/iwlist scan case an SSID _is_ passed from
userspace: the zero-length wildcard SSID. I made iw do that because an
active scan is more useful :-)

johannes

